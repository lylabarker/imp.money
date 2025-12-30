// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

/**
 * @title ImpVaultPublic
 * @notice Permissionless PancakeSwap V3 CLMM Deposit Vault
 * @dev Deposit USDT → Add to CLMM position → Earn $MONEY rewards
 */

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
        uint96, address, address token0, address token1, uint24 fee,
        int24, int24, uint128 liquidity, uint256, uint256, uint128, uint128
    );
    function increaseLiquidity(IncreaseLiquidityParams calldata) external payable returns (uint128, uint256, uint256);
}

interface IMoneyToken {
    function mint(address to, uint256 amount) external;
}

interface IController {
    function recordStake(address user, uint256 amount, uint256 planId, address referrer) external returns (uint256);
}

contract ImpVaultPublic is ReentrancyGuard {
    using SafeERC20 for IERC20;

    // Protocol Constants (Immutable)
    INonfungiblePositionManager public constant POSITION_MANAGER =
        INonfungiblePositionManager(0x46A15B0b27311cedF172AB29E4f4766fbE7F4364);
    IERC20 public constant USDT = IERC20(0x55d398326f99059fF775485246999027B3197955);
    IERC20 public constant USDC = IERC20(0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d);
    uint24 public constant TARGET_FEE = 500;
    uint256 public constant BASIS_POINTS = 10000;
    uint256 public constant MIN_DEPOSIT = 1e18;  // $1 minimum deposit
    uint256 public constant MAX_DEPOSIT = 100_000e18;  // $100K max per transaction
    uint256 public constant MAX_SLIPPAGE = 100;

    // Position Configuration (Immutable)
    uint256 public immutable tokenId;
    bool public immutable usdtIsToken0;
    
    // Reward Configuration (Immutable)
    IMoneyToken public immutable rewardToken;
    
    // Controller for stake tracking (Immutable)
    IController public immutable controller;
    
    // Bitcoin-style Halving Schedule (based on TVL milestones)
    // Era 0: 100 $MONEY/USDT, halves every era until $100M+
    uint256 public constant INITIAL_REWARD_RATE = 1_000_000;  // 100x in basis points
    uint256 public constant MIN_REWARD_RATE = 977;  // ~0.1x floor (after 10 halvings)
    
    // Halving thresholds (cumulative USDT deposited)
    uint256 public constant ERA_1_THRESHOLD = 100_000e18;      // $100K → 50x
    uint256 public constant ERA_2_THRESHOLD = 500_000e18;      // $500K → 25x
    uint256 public constant ERA_3_THRESHOLD = 1_000_000e18;    // $1M → 12.5x
    uint256 public constant ERA_4_THRESHOLD = 2_500_000e18;    // $2.5M → 6.25x
    uint256 public constant ERA_5_THRESHOLD = 5_000_000e18;    // $5M → 3.125x
    uint256 public constant ERA_6_THRESHOLD = 10_000_000e18;   // $10M → 1.56x
    uint256 public constant ERA_7_THRESHOLD = 25_000_000e18;   // $25M → 0.78x
    uint256 public constant ERA_8_THRESHOLD = 50_000_000e18;   // $50M → 0.39x
    uint256 public constant ERA_9_THRESHOLD = 75_000_000e18;   // $75M → 0.2x
    uint256 public constant ERA_10_THRESHOLD = 100_000_000e18; // $100M → 0.1x floor
    
    // Protocol Fee (Immutable) - 1% of rewards to handler
    uint256 public constant PROTOCOL_FEE = 100;  // 1% in basis points
    address public constant PROTOCOL_HANDLER = 0x5B50938E2cD0ee2bF2B780a89276Be54B6cB6604;
    
    // Protocol Statistics
    uint256 public totalDeposited;
    uint256 public depositCount;
    uint256 public totalRewardsDistributed;

    // Events
    event LiquidityAdded(address indexed provider, uint256 amount, uint128 liquidity, uint256 indexed stakeId);
    event RewardsDistributed(address indexed provider, uint256 amount);
    event RewardsFailed(address indexed provider, uint256 amount, bytes reason);
    event StakeRecorded(address indexed provider, uint256 indexed stakeId, uint256 amount, uint256 planId);
    event StakeRecordFailed(address indexed provider, uint256 amount, bytes reason);
    event RefundIssued(address indexed provider, uint256 amount);

    // Errors
    error InvalidPosition();
    error MinimumNotMet();
    error MaximumExceeded();
    error SlippageTooHigh();

    constructor(uint256 _tokenId, address _rewardToken, address _controller) {
        (,, address t0, address t1, uint24 fee,,, uint128 liq,,,,) = POSITION_MANAGER.positions(_tokenId);
        
        bool valid = (t0 == address(USDT) && t1 == address(USDC)) ||
                     (t0 == address(USDC) && t1 == address(USDT));
        if (!valid || fee != TARGET_FEE || liq == 0) revert InvalidPosition();
        
        tokenId = _tokenId;
        usdtIsToken0 = t0 == address(USDT);
        rewardToken = IMoneyToken(_rewardToken);
        controller = IController(_controller);
    }

    /**
     * @notice Add liquidity to the USDT/USDC pool
     * @dev Permissionless - anyone can deposit USDT and receive $MONEY
     * @param amount USDT amount to deposit (minimum $1 USDT)
     * @param planId The staking plan ID (for controller tracking)
     * @param referrer Optional referrer address (for affiliate rewards)
     */
    function addLiquidity(uint256 amount, uint256 planId, address referrer) external nonReentrant {
        if (amount < MIN_DEPOSIT) revert MinimumNotMet();
        if (amount > MAX_DEPOSIT) revert MaximumExceeded();
        
        USDT.safeTransferFrom(msg.sender, address(this), amount);
        USDT.forceApprove(address(POSITION_MANAGER), amount);
        
        uint256 a0 = usdtIsToken0 ? amount : 0;
        uint256 a1 = usdtIsToken0 ? 0 : amount;
        uint256 minA0 = (a0 * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        uint256 minA1 = (a1 * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        
        (uint128 liq, uint256 actual0, uint256 actual1) = POSITION_MANAGER.increaseLiquidity(
            INonfungiblePositionManager.IncreaseLiquidityParams({
                tokenId: tokenId,
                amount0Desired: a0,
                amount1Desired: a1,
                amount0Min: minA0,
                amount1Min: minA1,
                deadline: block.timestamp + 120
            })
        );
        
        uint256 actualUsdt = usdtIsToken0 ? actual0 : actual1;
        uint256 minUsdt = (amount * (BASIS_POINTS - MAX_SLIPPAGE)) / BASIS_POINTS;
        if (actualUsdt < minUsdt) revert SlippageTooHigh();
        
        // C-01 FIX: Refund unused USDT to user
        uint256 refund = amount - actualUsdt;
        if (refund > 0) {
            USDT.safeTransfer(msg.sender, refund);
            emit RefundIssued(msg.sender, refund);
        }
        
        depositCount++;
        totalDeposited += actualUsdt;  // M-04 FIX: Track actual deposited amount
        
        // Record stake in controller for tracking and future claims (uses actual amount)
        uint256 stakeId = 0;
        if (address(controller) != address(0)) {
            try controller.recordStake(msg.sender, actualUsdt, planId, referrer) returns (uint256 id) {
                stakeId = id;
                emit StakeRecorded(msg.sender, id, actualUsdt, planId);
            } catch (bytes memory reason) {
                emit StakeRecordFailed(msg.sender, actualUsdt, reason);
            }
        }
        
        emit LiquidityAdded(msg.sender, actualUsdt, liq, stakeId);
        
        // Distribute $MONEY rewards based on ACTUAL deposited amount (Bitcoin-style halving)
        if (address(rewardToken) != address(0)) {
            uint256 currentRate = getCurrentRewardRate();
            uint256 userReward = (actualUsdt * currentRate) / BASIS_POINTS;
            uint256 protocolFee = (userReward * PROTOCOL_FEE) / BASIS_POINTS;
            
            // Mint 100% to user
            try rewardToken.mint(msg.sender, userReward) {
                totalRewardsDistributed += userReward;
                emit RewardsDistributed(msg.sender, userReward);
            } catch (bytes memory reason) {
                emit RewardsFailed(msg.sender, userReward, reason);
            }
            
            // Mint extra 1% to protocol handler
            try rewardToken.mint(PROTOCOL_HANDLER, protocolFee) {
                totalRewardsDistributed += protocolFee;
                emit RewardsDistributed(PROTOCOL_HANDLER, protocolFee);
            } catch {}
        }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    //                            VIEW FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════════

    /**
     * @notice Get current reward rate based on TVL (Bitcoin-style halving)
     * @return rate Reward rate in basis points (divide by 10000 for multiplier)
     */
    function getCurrentRewardRate() public view returns (uint256 rate) {
        uint256 tvl = totalDeposited;
        
        if (tvl < ERA_1_THRESHOLD) return INITIAL_REWARD_RATE;           // 100x
        if (tvl < ERA_2_THRESHOLD) return INITIAL_REWARD_RATE / 2;       // 50x
        if (tvl < ERA_3_THRESHOLD) return INITIAL_REWARD_RATE / 4;       // 25x
        if (tvl < ERA_4_THRESHOLD) return INITIAL_REWARD_RATE / 8;       // 12.5x
        if (tvl < ERA_5_THRESHOLD) return INITIAL_REWARD_RATE / 16;      // 6.25x
        if (tvl < ERA_6_THRESHOLD) return INITIAL_REWARD_RATE / 32;      // 3.125x
        if (tvl < ERA_7_THRESHOLD) return INITIAL_REWARD_RATE / 64;      // 1.56x
        if (tvl < ERA_8_THRESHOLD) return INITIAL_REWARD_RATE / 128;     // 0.78x
        if (tvl < ERA_9_THRESHOLD) return INITIAL_REWARD_RATE / 256;     // 0.39x
        if (tvl < ERA_10_THRESHOLD) return INITIAL_REWARD_RATE / 512;    // 0.2x
        return MIN_REWARD_RATE;                                           // 0.1x floor
    }
    
    /**
     * @notice Get current halving era (0-10)
     */
    function getCurrentEra() external view returns (uint256) {
        uint256 tvl = totalDeposited;
        
        if (tvl < ERA_1_THRESHOLD) return 0;
        if (tvl < ERA_2_THRESHOLD) return 1;
        if (tvl < ERA_3_THRESHOLD) return 2;
        if (tvl < ERA_4_THRESHOLD) return 3;
        if (tvl < ERA_5_THRESHOLD) return 4;
        if (tvl < ERA_6_THRESHOLD) return 5;
        if (tvl < ERA_7_THRESHOLD) return 6;
        if (tvl < ERA_8_THRESHOLD) return 7;
        if (tvl < ERA_9_THRESHOLD) return 8;
        if (tvl < ERA_10_THRESHOLD) return 9;
        return 10;
    }
    
    /**
     * @notice Preview reward for a deposit amount
     */
    function previewReward(uint256 amount) external view returns (uint256) {
        return (amount * getCurrentRewardRate()) / BASIS_POINTS;
    }
}
