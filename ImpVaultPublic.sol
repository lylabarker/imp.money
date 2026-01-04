// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface INonfungiblePositionManager {
    struct IncreaseLiquidityParams {
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    function positions(uint256 tokenId) external view returns (
        uint96 nonce,
        address operator,
        address token0,
        address token1,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper,
        uint128 liquidity,
        uint256 feeGrowthInside0LastX128,
        uint256 feeGrowthInside1LastX128,
        uint128 tokensOwed0,
        uint128 tokensOwed1
    );
    function increaseLiquidity(IncreaseLiquidityParams calldata) external payable returns (uint128, uint256, uint256);
}

interface IController {
    function recordStake(address user, uint256 amount, uint256 planId, address referrer) external returns (uint256);
}

contract ImpVaultV7 is ReentrancyGuard {
    using SafeERC20 for IERC20;

    address public constant owner = address(0);

    INonfungiblePositionManager public constant POSITION_MANAGER =
        INonfungiblePositionManager(0x46A15B0b27311cedF172AB29E4f4766fbE7F4364);
    IERC721 public constant POSITION_NFT = 
        IERC721(0x46A15B0b27311cedF172AB29E4f4766fbE7F4364);
    IERC20 public constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 public constant USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    
    uint24 public constant TARGET_FEE = 500;
    uint256 public constant BASIS_POINTS = 10000;
    uint256 public constant MIN_DEPOSIT = 1e18;
    uint256 public constant MAX_DEPOSIT = 100_000e18;
    uint256 public constant MAX_SLIPPAGE = 100;

    uint256 public immutable tokenId;
    bool public immutable usdtIsToken0;
    IController public immutable controller;
    
    uint256 public totalDeposited;
    uint256 public depositCount;

    event Deposited(address indexed user, uint256 amount, uint256 indexed stakeId);
    event LiquidityAdded(uint256 amount, uint128 liquidity);
    event Refunded(address indexed user, uint256 amount);

    error InvalidPosition();
    error MinimumNotMet();
    error MaximumExceeded();
    error SlippageTooHigh();
    error PositionNotApproved();
    error NoLiquidityAdded();
    error NoController();

    constructor(uint256 _tokenId, address _controller) {
        if (_controller == address(0)) revert NoController();
        
        (address t0, ) = _validatePosition(_tokenId);
        
        tokenId = _tokenId;
        usdtIsToken0 = t0 == address(USDT);
        controller = IController(_controller);
    }

    function _validatePosition(uint256 _tokenId) private view returns (address t0, address t1) {
        uint24 fee;
        (,, t0, t1, fee,,,,,,,) = POSITION_MANAGER.positions(_tokenId);
        
        bool valid = (t0 == address(USDT) && t1 == address(USDC)) ||
                     (t0 == address(USDC) && t1 == address(USDT));
        if (!valid || fee != TARGET_FEE) revert InvalidPosition();
        
        return (t0, t1);
    }

    modifier validPosition() {
        address nftOwner = POSITION_NFT.ownerOf(tokenId);
        bool isApproved = POSITION_NFT.isApprovedForAll(nftOwner, address(this)) ||
                          POSITION_NFT.getApproved(tokenId) == address(this);
        if (!isApproved) revert PositionNotApproved();
        _;
    }

    function deposit(
        uint256 amount,
        uint256 planId,
        address referrer
    ) external nonReentrant validPosition returns (uint256 stakeId) {
        if (amount < MIN_DEPOSIT) revert MinimumNotMet();
        if (amount > MAX_DEPOSIT) revert MaximumExceeded();
        
        USDT.safeTransferFrom(msg.sender, address(this), amount);
        
        USDT.forceApprove(address(POSITION_MANAGER), amount);
        (uint128 liq, uint256 actualUsdt) = _addToPosition(amount);
        
        if (amount > actualUsdt) {
            USDT.safeTransfer(msg.sender, amount - actualUsdt);
            emit Refunded(msg.sender, amount - actualUsdt);
        }
        
        totalDeposited += actualUsdt;
        depositCount++;
        
        emit LiquidityAdded(actualUsdt, liq);
        
        stakeId = controller.recordStake(msg.sender, actualUsdt, planId, referrer);
        
        emit Deposited(msg.sender, actualUsdt, stakeId);
        
        return stakeId;
    }
    
    function _addToPosition(uint256 amount) internal returns (uint128 liq, uint256 actualUsdt) {
        uint256 a0 = usdtIsToken0 ? amount : 0;
        uint256 a1 = usdtIsToken0 ? 0 : amount;
        uint256 minA0 = (a0 * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        uint256 minA1 = (a1 * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        
        uint256 actual0;
        uint256 actual1;
        (liq, actual0, actual1) = POSITION_MANAGER.increaseLiquidity(
            INonfungiblePositionManager.IncreaseLiquidityParams({
                tokenId: tokenId,
                amount0Desired: a0,
                amount1Desired: a1,
                amount0Min: minA0,
                amount1Min: minA1,
                deadline: block.timestamp + 120
            })
        );
        
        actualUsdt = usdtIsToken0 ? actual0 : actual1;
        uint256 minUsdt = (amount * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        
        if (actualUsdt < minUsdt) revert SlippageTooHigh();
        if (liq == 0) revert NoLiquidityAdded();
    }
    
    function isPositionValid() external view returns (bool valid, string memory reason) {
        try POSITION_NFT.ownerOf(tokenId) returns (address nftOwner) {
            if (nftOwner == address(0)) return (false, "Position burned");
            
            bool approved = POSITION_NFT.isApprovedForAll(nftOwner, address(this)) ||
                          POSITION_NFT.getApproved(tokenId) == address(this);
            if (!approved) return (false, "Not approved");
            
            return (true, "Valid");
        } catch {
            return (false, "Position query failed");
        }
    }
   
    function getPositionLiquidity() external view returns (uint128) {
        (,,,,,,,uint128 liq,,,,) = POSITION_MANAGER.positions(tokenId);
        return liq;
    }
    
    function getStats() external view returns (
        uint256 totalUSDT,
        uint256 deposits,
        uint128 lpLiquidity
    ) {
        (,,,,,,,uint128 liq,,,,) = POSITION_MANAGER.positions(tokenId);
        return (totalDeposited, depositCount, liq);
    }
}
