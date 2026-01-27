# Contract Addresses

All IMP Money smart contracts are deployed on BNB Smart Chain (BSC) and are fully verified on BSCScan.

## Main Contracts

### ImpVaultV7
The main vault contract that holds all liquidity in a PancakeSwap V3 concentrated liquidity position (USDT/USDC).

| Property | Value |
|----------|-------|
| Address | `0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C` |
| Network | BNB Smart Chain (BSC) |
| Verified | ✅ Yes |
| Status | 🔒 IMMUTABLE |
| Admin Functions | NONE |

[View on BSCScan →](https://bscscan.com/address/0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C#code)

**Key Features:**
- Deposits directly to PancakeSwap V3 LP
- No withdraw function for owner (doesn't exist)
- Funds only accessible via user claims
- Holds all user deposits

### ImpTreasuryV7
The treasury contract that manages referral tracking, rank calculations, and reward distributions.

| Property | Value |
|----------|-------|
| Address | `0x69077f02A721d2EC2548DAeA35d96B5481165Dd0` |
| Network | BNB Smart Chain (BSC) |
| Verified | ✅ Yes |
| Owner | 🔒 `0x0000...0000` (Renounced) |
| Upgrade Possible | NO (owner = 0x0) |

[View on BSCScan →](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#readProxyContract)

**Key Features:**
- 21-level referral tracking (14% total)
- 7-rank differential bonus system
- Deposit, claim, withdraw functions
- UUPS proxy with renounced owner = frozen

## Deployer Information

For full transparency, the deployer wallet information is publicly published:

| Property | Value |
|----------|-------|
| Deployer Address | `0x1044EF645dC6d6Cb6636048f25D4Db3b98Ddcd13` |
| Status | Private key published (can't control anything) |

[View Deployer on BSCScan →](https://bscscan.com/address/0x1044EF645dC6d6Cb6636048f25D4Db3b98Ddcd13)

{% hint style="warning" %}
**Do NOT send funds to the deployer wallet!** The private key is public for transparency purposes. Since ownership is renounced to 0x0, this key has no power over the contracts.
{% endhint %}

## Token Addresses

### USDT (Tether)
The stablecoin used for deposits and payments.

| Property | Value |
|----------|-------|
| Address | `0x55d398326f99059fF775485246999027B3197955` |
| Symbol | USDT |
| Decimals | 18 |
| Network | BNB Smart Chain (BSC) |

[View on BSCScan →](https://bscscan.com/address/0x55d398326f99059fF775485246999027B3197955)

## Quick Copy Reference

```
Vault:    0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C
Treasury: 0x69077f02A721d2EC2548DAeA35d96B5481165Dd0
USDT:     0x55d398326f99059fF775485246999027B3197955
```

## How to Verify Ownership is Renounced

### Step 1: Go to BSCScan
Visit the [Treasury contract](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#readProxyContract)

### Step 2: Read Contract
1. Click "Read as Proxy"
2. Find `owner()` function
3. Click Query

### Step 3: Verify Result
Should return:
```
0x0000000000000000000000000000000000000000
```

This confirms **no one controls the contract**.

## Contract Functions

### User Functions (Always Available)
| Function | Description |
|----------|-------------|
| `deposit(amount, referrer)` | Deposit USDT with optional referrer |
| `claimYield(depositId)` | Claim accrued yield anytime |
| `withdraw(depositId)` | Withdraw principal after 21 days |
| `claimRewards()` | Claim referral + rank bonus rewards |
| `compound()` | Convert rewards into new deposit |

### Read-Only Functions
| Function | Returns |
|----------|---------|
| `totalDeposited()` | All-time deposit volume |
| `depositCount()` | Total number of deposits |
| `getBalance()` | Current treasury balance |

## Adding Tokens to Wallet

### Add USDT to MetaMask
1. Open MetaMask
2. Click "Import Token"
3. Paste: `0x55d398326f99059fF775485246999027B3197955`
4. Symbol: USDT
5. Decimals: 18

## Constants Hardcoded in Contracts

These values can NEVER be changed:

```solidity
uint256 public constant LOCK_PERIOD = 21 days;
uint256 public constant DAILY_RATE_BPS = 70;  // 0.7%
address public constant VAULT = 0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C;
```

---

→ [Contract Architecture](architecture.md)
→ [Security & Audits](security.md)
→ [Renounced Ownership](renounced.md)
