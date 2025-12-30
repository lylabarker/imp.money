// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 * ║                                                                          ║
 * ║    ██╗███╗   ███╗██████╗    ███╗   ███╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗║
 * ║    ██║████╗ ████║██╔══██╗   ████╗ ████║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝║
 * ║    ██║██╔████╔██║██████╔╝   ██╔████╔██║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝ ║
 * ║    ██║██║╚██╔╝██║██╔═══╝    ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝  ║
 * ║    ██║██║ ╚═╝ ██║██║   ██╗  ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████╗   ██║   ║
 * ║    ╚═╝╚═╝     ╚═╝╚═╝   ╚═╝  ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ║
 * ║                                                                          ║
 * ║                   V3 CLMM Liquidity Pool Protocol                        ║
 * ║                         https://imp.money                                ║
 * ║                  Docs: https://imp.money/docs                            ║
 * ║             Whitepaper: https://imp.money/whitepaper                     ║
 * ║            Dev Telegram: https://t.me/lylabarkerdev                      ║
 * ║                                                                          ║
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 * @title ImpVaultPublicOptimized
 * @author Imp.Money Team
 * @notice Permissionless USDT/USDC liquidity vault utilizing PancakeSwap V3 CLMM
 * @dev IMMUTABLE CONTRACT - OWNER: 0x0000000000000000000000000000000000000000
 *      No admin functions, fully renounced at deployment
 */

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// Interface definitions
interface INonfungiblePositionManager {
    struct IncreaseLiquidityParams {
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }
    
    struct DecreaseLiquidityParams {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }
    
    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
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
    function decreaseLiquidity(DecreaseLiquidityParams calldata) external payable returns (uint256, uint256);
    function collect(CollectParams calldata) external payable returns (uint256, uint256);
}

interface IMoneyToken {
    function mint(address to, uint256 amount) external;
}

interface IController {
    function recordStake(address user, uint256 amount, uint256 planId, address referrer) external returns (uint256);
}

contract ImpVaultPublicOptimized is ReentrancyGuard {
    using SafeERC20 for IERC20;

    // ═══════════════════════════════════════════════════════════════
    //                      CONSTANTS & STORAGE
    // ═══════════════════════════════════════════════════════════════
    
    /// @notice Contract has no owner - explicitly set to zero address
    address public constant owner = address(0);

    // IMMUTABLE Protocol Addresses
    INonfungiblePositionManager public constant POSITION_MANAGER =
        INonfungiblePositionManager(0x46A15B0b27311cedF172AB29E4f4766fbE7F4364);
    IERC721 public constant POSITION_NFT = 
        IERC721(0x46A15B0b27311cedF172AB29E4f4766fbE7F4364);
    IERC20 public constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 public constant USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    
    // IMMUTABLE Constants
    uint24 public constant TARGET_FEE = 500;
    uint256 public constant BASIS_POINTS = 10000;
    uint256 public constant MIN_DEPOSIT = 1e18;
    uint256 public constant MAX_DEPOSIT = 100_000e18;
    uint256 public constant MAX_SLIPPAGE = 100;
    uint256 public constant MIN_LIQUIDITY_BPS = 9000;
    
    // IMMUTABLE Yield Constants
    uint256 public constant LOCK_PERIOD = 21 days;
    uint256 public constant DAILY_RATE_BPS = 70;  
    uint256 public constant SECONDS_PER_DAY = 86400;
    uint256 public constant PROTOCOL_FEE_BPS = 500; 
    
    // Protocol Fee
    address public constant PROTOCOL_FEE_RECIPIENT = 0x748cD427322944Fd03622b81752409D29903Ddf9;

    // IMMUTABLE Position Config
    uint256 public immutable tokenId;
    bool public immutable usdtIsToken0;
    int24 public immutable positionTickLower;
    int24 public immutable positionTickUpper;
    uint128 public immutable initialLiquidity;
    
    // IMMUTABLE Reward Config
    IMoneyToken public immutable rewardToken;
    IController public immutable controller;
    
    // IMMUTABLE Halving Schedule
    uint256 public constant INITIAL_REWARD_RATE = 100_000;
    uint256 public constant MIN_REWARD_RATE = 100;
    
    // Era thresholds stored in an array to reduce variable count
    uint256[10] private eraThresholds = [
        100_000e18,     // ERA_1_THRESHOLD
        500_000e18,     // ERA_2_THRESHOLD
        1_000_000e18,   // ERA_3_THRESHOLD
        2_500_000e18,   // ERA_4_THRESHOLD
        5_000_000e18,   // ERA_5_THRESHOLD
        10_000_000e18,  // ERA_6_THRESHOLD
        25_000_000e18,  // ERA_7_THRESHOLD
        50_000_000e18,  // ERA_8_THRESHOLD
        75_000_000e18,  // ERA_9_THRESHOLD
        100_000_000e18  // ERA_10_THRESHOLD
    ];
    
    uint256 public constant ABSOLUTE_MAX_SUPPLY = 1_000_000_000_000e18;
    
    // User Deposit Tracking
    struct Deposit {
        uint256 principal;
        uint128 liquidityShare;
        uint256 depositTime;
        uint256 claimedRewards;
        bool withdrawn;
    }
    
    mapping(address => Deposit[]) public userDeposits;
    
    // Statistics
    uint256 public totalDeposited;
    uint256 public totalLiquidityShares;
    uint256 public depositCount;
    uint256 public totalRewardsDistributed;
    uint256 public totalYieldPaid;
    uint256 public totalProtocolFees;

    // ═══════════════════════════════════════════════════════════════
    //                           EVENTS
    // ═══════════════════════════════════════════════════════════════
    
    // Deposit Events
    event DepositReceived(address indexed user, uint256 amount, uint256 timestamp);
    event ProtocolFeeCollected(address indexed user, uint256 feeAmount, address indexed recipient);
    event LiquidityAdded(address indexed provider, uint256 amount, uint128 liquidity, uint256 indexed depositId);
    event RefundIssued(address indexed provider, uint256 amount);
    event DepositRecorded(address indexed user, uint256 indexed depositId, uint256 principal, uint128 liquidity);
    
    // Reward Events
    event RewardsDistributed(address indexed provider, uint256 amount);
    event StakeRecorded(address indexed provider, uint256 indexed stakeId, uint256 amount, uint256 planId);
    event RewardRateChanged(uint256 oldRate, uint256 newRate, uint256 totalDeposited);
    
    // Yield Events
    event YieldAccrued(address indexed user, uint256 indexed depositId, uint256 grossYield, uint256 netYield);
    event YieldClaimed(address indexed user, uint256 indexed depositId, uint256 amount);
    event YieldRecompounded(address indexed user, uint256 indexed oldDepositId, uint256 indexed newDepositId, uint256 amount);
    event CapitalCompounded(address indexed user, uint256 indexed oldDepositId, uint256 indexed newDepositId, uint256 amount);
    
    // Withdrawal Events
    event WithdrawalInitiated(address indexed user, uint256 indexed depositId, uint256 principal);
    event CapitalWithdrawn(address indexed user, uint256 indexed depositId, uint256 principal, uint256 yield);
    event LiquidityRemoved(address indexed user, uint128 liquidityRemoved, uint256 amountReceived);

    // ═══════════════════════════════════════════════════════════════
    //                           ERRORS
    // ═══════════════════════════════════════════════════════════════
    
    error InvalidPosition();
    error MinimumNotMet();
    error MaximumExceeded();
    error SlippageTooHigh();
    error PositionNotApproved();
    error NoLiquidityAdded();
    error InsufficientLiquidityAdded();
    error AbsoluteSupplyCapReached();
    error InvalidDepositId();
    error AlreadyWithdrawn();
    error StillLocked();
    error NoRewardsToClaim();
    error InsufficientLiquidity();
    error WithdrawalSlippageExceeded();
    error RecompoundAmountTooLow();

    // ═══════════════════════════════════════════════════════════════
    //                        CONSTRUCTOR
    // ═══════════════════════════════════════════════════════════════

    constructor(uint256 _tokenId, address _rewardToken, address _controller) {
        // Validate position
        (address t0, address t1) = _validatePosition(_tokenId);
        
        // Check approval
        _checkApproval(_tokenId);
        
        // Get position details
        (int24 tickLower, int24 tickUpper, uint128 liq) = _getPositionDetails(_tokenId);
        
        // Set immutable variables
        tokenId = _tokenId;
        usdtIsToken0 = t0 == address(USDT);
        positionTickLower = tickLower;
        positionTickUpper = tickUpper;
        initialLiquidity = liq;
        rewardToken = IMoneyToken(_rewardToken);
        controller = IController(_controller);
    }

    // ═══════════════════════════════════════════════════════════════
    //                      HELPER FUNCTIONS
    // ═══════════════════════════════════════════════════════════════

    // Helper function to validate position and get token0/token1
    function _validatePosition(uint256 _tokenId) private view returns (address t0, address t1) {
        uint24 fee;
        (,, t0, t1, fee,,,,,,,) = POSITION_MANAGER.positions(_tokenId);
        
        // Validate token pair
        bool valid = (t0 == address(USDT) && t1 == address(USDC)) ||
                     (t0 == address(USDC) && t1 == address(USDT));
        if (!valid || fee != TARGET_FEE) revert InvalidPosition();
        
        return (t0, t1);
    }
    
    // Helper function to check NFT approval
    function _checkApproval(uint256 _tokenId) private view {
        address nftOwner = POSITION_NFT.ownerOf(_tokenId);
        bool isApproved = POSITION_NFT.isApprovedForAll(nftOwner, address(this)) ||
                          POSITION_NFT.getApproved(_tokenId) == address(this);
        if (!isApproved) revert PositionNotApproved();
    }
    
    // Helper function to get position details
    function _getPositionDetails(uint256 _tokenId) private view returns (int24 tickLower, int24 tickUpper, uint128 liq) {
        (,,,,, tickLower, tickUpper, liq,,,,) = POSITION_MANAGER.positions(_tokenId);
        if (liq == 0) revert InvalidPosition();
        return (tickLower, tickUpper, liq);
    }

    modifier validPosition() {
        address nftOwner = POSITION_NFT.ownerOf(tokenId);
        bool isApproved = POSITION_NFT.isApprovedForAll(nftOwner, address(this)) ||
                          POSITION_NFT.getApproved(tokenId) == address(this);
        if (!isApproved) revert PositionNotApproved();
        _;
    }

    // ═══════════════════════════════════════════════════════════════
    //                         DEPOSIT
    // ═══════════════════════════════════════════════════════════════

    function addLiquidity(
        uint256 amount,
        uint256 planId,
        address referrer
    ) external nonReentrant validPosition {
        if (amount < MIN_DEPOSIT) revert MinimumNotMet();
        if (amount > MAX_DEPOSIT) revert MaximumExceeded();
        
        emit DepositReceived(msg.sender, amount, block.timestamp);
        
        // Transfer full USDT amount from user
        USDT.safeTransferFrom(msg.sender, address(this), amount);
        
        // Approve full amount for LP
        USDT.forceApprove(address(POSITION_MANAGER), amount);
        
        // Add full amount to liquidity pool
        (uint128 liq, uint256 actualUsdt) = _addToPosition(amount);
        
        // Refund unused amount
        if (amount > actualUsdt) {
            USDT.safeTransfer(msg.sender, amount - actualUsdt);
            emit RefundIssued(msg.sender, amount - actualUsdt);
        }
        
        // Record deposit as FULL amount deposited (user is credited 100%)
        uint256 depositId = _recordDeposit(msg.sender, actualUsdt, liq);
        
        // Handle controller stake recording
        _recordControllerStake(msg.sender, actualUsdt, planId, referrer);
        
        emit LiquidityAdded(msg.sender, actualUsdt, liq, depositId);
        
        // Distribute rewards based on full deposited amount
        _distributeRewards(msg.sender, actualUsdt);
        
        // Withdraw 5% protocol fee FROM POOL and send to fee recipient
        _collectProtocolFee(actualUsdt);
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
        
        // Note: Ratio check removed to support USDT-only deposits when position is out-of-range
        // The slippage check above provides sufficient protection
    }
    
    function _recordDeposit(address user, uint256 actualUsdt, uint128 liq) internal returns (uint256 depositId) {
        depositId = userDeposits[user].length;
        userDeposits[user].push(Deposit({
            principal: actualUsdt,
            liquidityShare: liq,
            depositTime: block.timestamp,
            claimedRewards: 0,
            withdrawn: false
        }));
        
        emit DepositRecorded(user, depositId, actualUsdt, liq);
        
        depositCount++;
        totalDeposited += actualUsdt;
        totalLiquidityShares += liq;
        
        return depositId;
    }
    
    function _recordControllerStake(address user, uint256 actualUsdt, uint256 planId, address referrer) internal {
        if (address(controller) != address(0)) {
            uint256 stakeId = controller.recordStake(user, actualUsdt, planId, referrer);
            emit StakeRecorded(user, stakeId, actualUsdt, planId);
        }
    }
    
    function _distributeRewards(address user, uint256 actualUsdt) internal {
        if (address(rewardToken) == address(0)) return;
        
        uint256 oldRate = getCurrentRewardRate();
        uint256 userReward = (actualUsdt * oldRate) / BASIS_POINTS;
        
        if (totalRewardsDistributed + userReward > ABSOLUTE_MAX_SUPPLY) {
            revert AbsoluteSupplyCapReached();
        }
        
        rewardToken.mint(user, userReward);
        totalRewardsDistributed += userReward;
        emit RewardsDistributed(user, userReward);
        
        uint256 newRate = getCurrentRewardRate();
        if (newRate != oldRate) {
            emit RewardRateChanged(oldRate, newRate, totalDeposited);
        }
    }
    
    /**
     * @notice Withdraw 5% protocol fee from pool and send to fee recipient
     * @param depositAmount The amount deposited to calculate fee from
     */
    function _collectProtocolFee(uint256 depositAmount) internal {
        uint256 protocolFee = (depositAmount * PROTOCOL_FEE_BPS) / BASIS_POINTS;
        if (protocolFee == 0) return;
        
        // Calculate liquidity needed for EXACT fee (no buffer)
        uint128 feeLiquidity = _calculateLiquidityForFee(protocolFee);
        if (feeLiquidity == 0) return;
        
        // Withdraw from pool directly to protocol fee recipient
        uint256 actualFee = _withdrawLiquidityToRecipient(PROTOCOL_FEE_RECIPIENT, feeLiquidity, protocolFee);
        
        // Cap at expected fee to prevent over-collection
        if (actualFee > protocolFee) {
            actualFee = protocolFee;
        }
        
        totalProtocolFees += actualFee;
        emit ProtocolFeeCollected(msg.sender, actualFee, PROTOCOL_FEE_RECIPIENT);
    }
    
    /**
     * @notice Calculate liquidity needed for exact protocol fee (no buffer)
     * @dev Used only for protocol fee collection to ensure exactly 5%
     */
    function _calculateLiquidityForFee(uint256 amount) internal view returns (uint128) {
        (,,,,,,,uint128 currentLiquidity,,,,) = POSITION_MANAGER.positions(tokenId);
        
        if (totalDeposited == 0 || currentLiquidity == 0) return 0;
        
        // Proportional liquidity: amount / totalDeposited * currentLiquidity
        // NO buffer added - we want exact 5%
        uint256 liquidityNeeded = (amount * uint256(currentLiquidity)) / totalDeposited;
        
        return liquidityNeeded > currentLiquidity ? currentLiquidity : uint128(liquidityNeeded);
    }
    
    /**
     * @notice Withdraw liquidity from pool to a specific recipient (for protocol fees)
     * @param recipient The address to receive the tokens
     * @param liquidityToRemove Amount of liquidity to remove
     * @param expectedAmount Expected token amount for slippage check
     * @return actualAmount The actual amount received
     */
    function _withdrawLiquidityToRecipient(
        address recipient,
        uint128 liquidityToRemove,
        uint256 expectedAmount
    ) internal returns (uint256 actualAmount) {
        if (liquidityToRemove == 0) return 0;
        
        (,,,,,,,uint128 currentLiquidity,,,,) = POSITION_MANAGER.positions(tokenId);
        if (currentLiquidity == 0) return 0;
        
        if (liquidityToRemove > currentLiquidity) {
            liquidityToRemove = currentLiquidity;
        }
        
        // Allow higher slippage for protocol fee collection (5%)
        uint256 minAmount = (expectedAmount * 9500) / BASIS_POINTS;
        uint256 minA0 = usdtIsToken0 ? minAmount : 0;
        uint256 minA1 = usdtIsToken0 ? 0 : minAmount;
        
        // Decrease liquidity
        (uint256 amount0, uint256 amount1) = POSITION_MANAGER.decreaseLiquidity(
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidityToRemove,
                amount0Min: minA0,
                amount1Min: minA1,
                deadline: block.timestamp + 120
            })
        );
        
        // Collect tokens directly to recipient
        (uint256 collected0, uint256 collected1) = POSITION_MANAGER.collect(
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: recipient,
                amount0Max: uint128(amount0),
                amount1Max: uint128(amount1)
            })
        );
        
        actualAmount = usdtIsToken0 ? collected0 : collected1;
        
        emit LiquidityRemoved(recipient, liquidityToRemove, actualAmount);
        
        return actualAmount;
    }

    // ═══════════════════════════════════════════════════════════════
    //                    YIELD CALCULATION
    // ═══════════════════════════════════════════════════════════════
    
    /**
     * @notice Calculate accrued yield for a deposit
     * @dev User receives 100% of yield. Protocol fee is only charged on new deposits.
     * @param user The user address
     * @param depositId The deposit index
     * @return totalYield Total yield accrued
     * @return pendingYield Yield not yet claimed (user gets 100%)
     */
    function calculateAccruedYield(address user, uint256 depositId) public view returns (
        uint256 totalYield,
        uint256 pendingYield,
        uint256 /* unused - kept for interface compatibility */
    ) {
        if (depositId >= userDeposits[user].length) return (0, 0, 0);
        
        Deposit memory d = userDeposits[user][depositId];
        if (d.withdrawn || d.principal == 0) return (0, 0, 0);
        
        // Calculate time elapsed (capped at 21 days)
        uint256 maxRewardTime = d.depositTime + LOCK_PERIOD;
        uint256 rewardEndTime = block.timestamp > maxRewardTime ? maxRewardTime : block.timestamp;
        uint256 timeElapsed = rewardEndTime - d.depositTime;
        
        // Total yield = principal * 0.7% * days (user gets 100%)
        totalYield = (d.principal * DAILY_RATE_BPS * timeElapsed) / (BASIS_POINTS * SECONDS_PER_DAY);
        
        // Subtract already claimed
        if (totalYield <= d.claimedRewards) return (0, 0, 0);
        
        pendingYield = totalYield - d.claimedRewards;
        
        // No protocol fee on yield - user gets 100%
        return (totalYield, pendingYield, 0);
    }

    // ═══════════════════════════════════════════════════════════════
    //                    CLAIM YIELD ONLY
    // ═══════════════════════════════════════════════════════════════
    
    function claimYield(uint256 depositId) external nonReentrant validPosition {
        if (depositId >= userDeposits[msg.sender].length) revert InvalidDepositId();
        
        Deposit storage d = userDeposits[msg.sender][depositId];
        if (d.withdrawn) revert AlreadyWithdrawn();
        
        (, uint256 pendingYield,) = calculateAccruedYield(msg.sender, depositId);
        if (pendingYield == 0) revert NoRewardsToClaim();
        
        emit YieldAccrued(msg.sender, depositId, pendingYield, pendingYield);
        
        // Update claimed amount
        d.claimedRewards += pendingYield;
        
        // Calculate liquidity needed for yield payout
        uint128 yieldLiquidity = _calculateLiquidityForAmount(pendingYield);
        
        // Remove liquidity and send 100% to user (no fee on claim)
        uint256 actualPayout = _withdrawLiquidityDirect(msg.sender, yieldLiquidity, pendingYield);
        
        totalYieldPaid += actualPayout;
        
        emit YieldClaimed(msg.sender, depositId, actualPayout);
    }

    // ═══════════════════════════════════════════════════════════════
    //                      RECOMPOUND YIELD
    // ═══════════════════════════════════════════════════════════════
    
    /**
     * @notice Recompound accrued yield into a new deposit (5% protocol fee applies)
     * @dev Yield is withdrawn from pool then re-deposited as new position
     * @param depositId The deposit to recompound yield from
     * @return newDepositId The ID of the new deposit created
     */
    function recompound(uint256 depositId) external nonReentrant validPosition returns (uint256 newDepositId) {
        if (depositId >= userDeposits[msg.sender].length) revert InvalidDepositId();
        
        Deposit storage d = userDeposits[msg.sender][depositId];
        if (d.withdrawn) revert AlreadyWithdrawn();
        
        (, uint256 pendingYield,) = calculateAccruedYield(msg.sender, depositId);
        if (pendingYield == 0) revert NoRewardsToClaim();
        if (pendingYield < MIN_DEPOSIT) revert RecompoundAmountTooLow();
        
        // Mark yield as claimed
        d.claimedRewards += pendingYield;
        
        // Withdraw yield from pool to this contract (not user)
        uint128 yieldLiquidity = _calculateLiquidityForAmount(pendingYield);
        uint256 actualYield = _withdrawLiquidityToContract(yieldLiquidity, pendingYield);
        
        if (actualYield < MIN_DEPOSIT) revert RecompoundAmountTooLow();
        
        // Re-deposit the yield (this applies 5% protocol fee)
        USDT.forceApprove(address(POSITION_MANAGER), actualYield);
        (uint128 liq, uint256 actualUsdt) = _addToPosition(actualYield);
        
        // Record as new deposit
        newDepositId = _recordDeposit(msg.sender, actualUsdt, liq);
        
        // Record stake with controller (triggers 14% referral distribution)
        // Pass address(0) as referrer - user already has referrer from initial deposit
        _recordControllerStake(msg.sender, actualUsdt, 0, address(0));
        
        // Distribute MONEY rewards based on recompounded amount
        _distributeRewards(msg.sender, actualUsdt);
        
        // Collect 5% protocol fee from the recompounded amount
        _collectProtocolFee(actualUsdt);
        
        emit YieldRecompounded(msg.sender, depositId, newDepositId, actualUsdt);
        
        return newDepositId;
    }
    
    /**
     * @notice Compound capital when unlocked - withdraws principal + yield and re-deposits (5% protocol fee applies)
     * @dev Only callable after lock period ends. Creates new deposit with 21-day lock.
     * @param depositId The deposit to compound
     * @return newDepositId The ID of the new deposit created
     */
    function compoundCapital(uint256 depositId) external nonReentrant validPosition returns (uint256 newDepositId) {
        if (depositId >= userDeposits[msg.sender].length) revert InvalidDepositId();
        
        Deposit storage d = userDeposits[msg.sender][depositId];
        if (d.withdrawn) revert AlreadyWithdrawn();
        if (block.timestamp < d.depositTime + LOCK_PERIOD) revert StillLocked();
        
        // Calculate remaining yield
        (, uint256 pendingYield,) = calculateAccruedYield(msg.sender, depositId);
        
        // Total to compound = principal + yield
        uint256 totalToCompound = d.principal + pendingYield;
        if (totalToCompound < MIN_DEPOSIT) revert RecompoundAmountTooLow();
        
        // Mark old deposit as withdrawn
        d.withdrawn = true;
        d.claimedRewards += pendingYield;
        
        // Update totals for old deposit
        totalDeposited -= d.principal;
        totalLiquidityShares -= d.liquidityShare;
        totalYieldPaid += pendingYield;
        
        emit WithdrawalInitiated(msg.sender, depositId, d.principal);
        
        // Withdraw all liquidity to this contract (not user)
        uint256 actualWithdrawn = _withdrawLiquidityToContract(d.liquidityShare, totalToCompound);
        
        if (actualWithdrawn < MIN_DEPOSIT) revert RecompoundAmountTooLow();
        
        // Re-deposit the full amount (principal + yield)
        USDT.forceApprove(address(POSITION_MANAGER), actualWithdrawn);
        (uint128 liq, uint256 actualUsdt) = _addToPosition(actualWithdrawn);
        
        // Record as new deposit
        newDepositId = _recordDeposit(msg.sender, actualUsdt, liq);
        
        // Record stake with controller (triggers 14% referral distribution)
        // Pass address(0) as referrer - user already has referrer from initial deposit
        _recordControllerStake(msg.sender, actualUsdt, 0, address(0));
        
        // Distribute MONEY rewards based on compounded amount
        _distributeRewards(msg.sender, actualUsdt);
        
        // Collect 5% protocol fee from the compounded amount
        _collectProtocolFee(actualUsdt);
        
        emit CapitalCompounded(msg.sender, depositId, newDepositId, actualUsdt);
        
        return newDepositId;
    }
    
    /**
     * @notice Withdraw liquidity from pool to this contract (for recompounding)
     */
    function _withdrawLiquidityToContract(
        uint128 liquidityToRemove,
        uint256 expectedAmount
    ) internal returns (uint256 actualAmount) {
        if (liquidityToRemove == 0) return 0;
        
        (,,,,,,,uint128 currentLiquidity,,,,) = POSITION_MANAGER.positions(tokenId);
        if (currentLiquidity == 0) revert InsufficientLiquidity();
        
        if (liquidityToRemove > currentLiquidity) {
            liquidityToRemove = currentLiquidity;
        }
        
        uint256 minAmount = (expectedAmount * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        uint256 minA0 = usdtIsToken0 ? minAmount : 0;
        uint256 minA1 = usdtIsToken0 ? 0 : minAmount;
        
        // Decrease liquidity
        (uint256 amount0, uint256 amount1) = POSITION_MANAGER.decreaseLiquidity(
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidityToRemove,
                amount0Min: minA0,
                amount1Min: minA1,
                deadline: block.timestamp + 120
            })
        );
        
        // Collect tokens to this contract for re-deposit
        (uint256 collected0, uint256 collected1) = POSITION_MANAGER.collect(
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: uint128(amount0),
                amount1Max: uint128(amount1)
            })
        );
        
        actualAmount = usdtIsToken0 ? collected0 : collected1;
        
        return actualAmount;
    }

    // ═══════════════════════════════════════════════════════════════
    //                 WITHDRAW CAPITAL + YIELD
    // ═══════════════════════════════════════════════════════════════
    
    function withdraw(uint256 depositId) external nonReentrant validPosition {
        if (depositId >= userDeposits[msg.sender].length) revert InvalidDepositId();
        
        Deposit storage d = userDeposits[msg.sender][depositId];
        if (d.withdrawn) revert AlreadyWithdrawn();
        if (block.timestamp < d.depositTime + LOCK_PERIOD) revert StillLocked();
        
        emit WithdrawalInitiated(msg.sender, depositId, d.principal);
        
        // Calculate remaining yield (user gets 100%)
        (, uint256 pendingYield,) = calculateAccruedYield(msg.sender, depositId);
        
        // Mark as withdrawn
        d.withdrawn = true;
        d.claimedRewards += pendingYield;
        
        // Total payout = 100% principal + 100% yield
        uint256 totalPayout = d.principal + pendingYield;
        
        // Update totals
        totalDeposited -= d.principal;
        totalLiquidityShares -= d.liquidityShare;
        totalYieldPaid += pendingYield;
        
        // Remove user's liquidity share and send full payout to user
        _withdrawLiquidityDirect(msg.sender, d.liquidityShare, totalPayout);
        
        emit CapitalWithdrawn(msg.sender, depositId, d.principal, pendingYield);
    }

    // ═══════════════════════════════════════════════════════════════
    //                 INTERNAL LIQUIDITY FUNCTIONS
    // ═══════════════════════════════════════════════════════════════
    
    function _calculateLiquidityForAmount(uint256 amount) internal view returns (uint128) {
        (,,,,,,,uint128 currentLiquidity,,,,) = POSITION_MANAGER.positions(tokenId);
        
        if (totalDeposited == 0 || currentLiquidity == 0) return 0;
        
        // Proportional liquidity: amount / totalDeposited * currentLiquidity
        uint256 liquidityNeeded = (amount * uint256(currentLiquidity)) / totalDeposited;
        
        // Add 10% buffer for slippage
        liquidityNeeded = (liquidityNeeded * 110) / 100;
        
        return liquidityNeeded > currentLiquidity ? currentLiquidity : uint128(liquidityNeeded);
    }
    
    /**
     * @notice Withdraw liquidity from the pool and send directly to recipient
     * @param recipient The address to receive the tokens
     * @param liquidityToRemove Amount of liquidity to remove
     * @param expectedAmount Expected token amount for slippage check
     * @return actualAmount The actual amount received
     */
    function _withdrawLiquidityDirect(
        address recipient,
        uint128 liquidityToRemove,
        uint256 expectedAmount
    ) internal returns (uint256 actualAmount) {
        if (liquidityToRemove == 0) return 0;
        
        (,,,,,,,uint128 currentLiquidity,,,,) = POSITION_MANAGER.positions(tokenId);
        if (currentLiquidity == 0) revert InsufficientLiquidity();
        
        if (liquidityToRemove > currentLiquidity) {
            liquidityToRemove = currentLiquidity;
        }
        
        uint256 minAmount = (expectedAmount * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        uint256 minA0 = usdtIsToken0 ? minAmount : 0;
        uint256 minA1 = usdtIsToken0 ? 0 : minAmount;
        
        // Decrease liquidity
        (uint256 amount0, uint256 amount1) = POSITION_MANAGER.decreaseLiquidity(
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidityToRemove,
                amount0Min: minA0,
                amount1Min: minA1,
                deadline: block.timestamp + 120
            })
        );
        
        // Collect tokens directly to recipient
        (uint256 collected0, uint256 collected1) = POSITION_MANAGER.collect(
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: recipient,
                amount0Max: uint128(amount0),
                amount1Max: uint128(amount1)
            })
        );
        
        actualAmount = usdtIsToken0 ? collected0 : collected1;
        
        // Validate output slippage
        if (actualAmount < minAmount) revert WithdrawalSlippageExceeded();
        
        emit LiquidityRemoved(recipient, liquidityToRemove, actualAmount);
        
        return actualAmount;
    }

    // ═══════════════════════════════════════════════════════════════
    //                       VIEW FUNCTIONS
    // ═══════════════════════════════════════════════════════════════

    function getCurrentRewardRate() public view returns (uint256 rate) {
        uint256 deposits = totalDeposited;
        
        // Optimized to use a loop instead of multiple if statements
        for (uint256 i = 0; i < eraThresholds.length; i++) {
            if (deposits < eraThresholds[i]) {
                return INITIAL_REWARD_RATE >> i; // Equivalent to division by 2^i
            }
        }
        
        return MIN_REWARD_RATE;
    }
    
    function getCurrentEra() external view returns (uint256) {
        uint256 deposits = totalDeposited;
        
        for (uint256 i = 0; i < eraThresholds.length; i++) {
            if (deposits < eraThresholds[i]) {
                return i;
            }
        }
        
        return 10;
    }
    
    function previewReward(uint256 amount) external view returns (uint256) {
        return (amount * getCurrentRewardRate()) / BASIS_POINTS;
    }
    
    function getUserDeposit(address user, uint256 depositId) external view returns (
        uint256 principal,
        uint128 liquidityShare,
        uint256 depositTime,
        uint256 unlockTime,
        uint256 claimedRewards,
        uint256 pendingYield,
        bool isLocked,
        bool withdrawn
    ) {
        if (depositId >= userDeposits[user].length) revert InvalidDepositId();
        
        Deposit memory d = userDeposits[user][depositId];
        (, uint256 netYield,) = calculateAccruedYield(user, depositId);
        
        return (
            d.principal,
            d.liquidityShare,
            d.depositTime,
            d.depositTime + LOCK_PERIOD,
            d.claimedRewards,
            netYield,
            block.timestamp < d.depositTime + LOCK_PERIOD,
            d.withdrawn
        );
    }
    
    function getUserDepositCount(address user) external view returns (uint256) {
        return userDeposits[user].length;
    }
    
    function isPositionValid() external view returns (bool valid, string memory reason) {
        try POSITION_NFT.ownerOf(tokenId) returns (address nftOwner) {
            if (nftOwner == address(0)) return (false, "Position burned");
            
            bool approved = POSITION_NFT.isApprovedForAll(nftOwner, address(this)) ||
                          POSITION_NFT.getApproved(tokenId) == address(this);
           if (!approved) return (false, "Not approved");
           
           (,,,,,,,uint128 liq,,,,) = POSITION_MANAGER.positions(tokenId);
           if (liq == 0) return (false, "No liquidity");
           
           return (true, "Valid");
       } catch {
           return (false, "Position query failed");
       }
   }
   
   function getProtocolStats() external view returns (
       uint256 tvl,
       uint256 deposits,
       uint256 yieldPaid,
       uint256 protocolFees,
       uint256 moneyDistributed
   ) {
       return (
           totalDeposited,
           depositCount,
           totalYieldPaid,
           totalProtocolFees,
           totalRewardsDistributed
       );
   }
}
