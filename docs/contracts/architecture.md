# Contract Architecture

Overview of IMP Money's smart contract structure.

## System Overview

```
┌─────────────────┐    ┌──────────────────┐
│   User Wallet   │───▶│  ImpTreasuryV7   │
└─────────────────┘    └────────┬─────────┘
                                │
                    ┌───────────┴───────────┐
                    ▼                       ▼
            ┌───────────┐           ┌───────────────┐
            │ImpVaultV7 │──────────▶│ PancakeSwap   │
            │           │           │ V3 LP         │
            └───────────┘           └───────────────┘
```

## Contract Roles

### ImpTreasuryV7 (0x69077f02A721d2EC2548DAeA35d96B5481165Dd0)
**Primary entry point for user interactions - Referral & Rewards Controller**

Functions:
- `deposit()` - Accept USDT deposits
- `withdraw()` - Process withdrawals after 21 days
- `claimYield()` - Claim accrued ROI
- `claimRewards()` - Claim referral + rank bonus rewards
- `compound()` - Convert rewards to new deposit
- 21-level referral tracking (14% total)
- 7-rank differential bonus system

### ImpVaultV7 (0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C)
**Liquidity & Yield Engine - Holds all funds**

Functions:
- Deposits directly to PancakeSwap V3 LP
- USDT/USDC concentrated liquidity position
- No withdraw function for owner (doesn't exist)
- Funds only accessible via user claims

## Upgrade Pattern

IMP Money uses upgradeable proxy contracts:

```
┌──────────────┐       ┌──────────────┐
│    Proxy     │ ────▶ │   Logic V1   │
│ (Storage)    │       │              │
└──────────────┘       └──────────────┘
                              ▼ upgrade
                       ┌──────────────┐
                       │   Logic V2   │
                       │              │
                       └──────────────┘
```

Benefits:
- Bug fixes without migration
- Feature additions possible
- User funds untouched
- State preserved

## Security Controls

### Access Control
- Owner functions: Limited admin capabilities
- Renounced vault: No owner controls on core funds
- Time locks: Delayed sensitive operations

### Safety Mechanisms
- Reentrancy guards on all external calls
- SafeERC20 for token transfers
- Overflow protection (Solidity 0.8+)
- Emergency pause capability

## Data Flow

### Deposit Flow
```
1. User approves USDT
2. User calls deposit(amount, referrer)
3. Controller receives USDT
4. Controller records position
5. Referral commissions distributed
6. Funds transferred to Vault
7. Vault deploys to LP
```

### Claim Flow
```
1. User calls claim()
2. Controller calculates owed ROI
3. Vault releases USDT
4. USDT sent to user wallet
5. Position timestamp updated
```

### Withdraw Flow
```
1. User calls withdraw(amount)
2. Controller verifies 21-day lock expired
3. Vault releases funds
4. Any unclaimed ROI included
5. USDT sent to user wallet
6. Position updated/closed
```

## Audited Components

All contracts audited by CertiK:
- ✅ ImpVaultV7
- ✅ ImpTreasuryV7
- ✅ UUPS Proxy implementation

[View CertiK Audit →](https://skynet.certik.com/projects/imp-money)

---

→ [Contract Addresses](addresses.md)
→ [Security & Audits](security.md)
