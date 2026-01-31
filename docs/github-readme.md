# IMP Money

<div align="center">

![IMP Money](https://imp.money/favicon.svg)

**Decentralized DeFi Yield Protocol on BNB Smart Chain**

[![CertiK Audit](https://img.shields.io/badge/CertiK-Audited-00FF94?style=for-the-badge)](https://skynet.certik.com/projects/imp-money)
[![BSC](https://img.shields.io/badge/BNB-Smart%20Chain-F0B90B?style=for-the-badge)](https://bscscan.com)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

[Website](https://imp.money) • [Documentation](https://docs.imp.money) • [Telegram](https://t.me/impmoneychat) • [CertiK Audit](https://skynet.certik.com/projects/imp-money)

</div>

---

## Overview

IMP Money is a trustless DeFi protocol that generates yield through concentrated liquidity provision on PancakeSwap V3, combined with a 21-level referral system.

### Key Features

- 🎯 **0.7% Daily ROI** — Earned from PancakeSwap V3 trading fees
- 🔗 **21-Level Referrals** — Earn 14% total commissions
- 👑 **7-Rank Leadership** — Earn up to 7.5% on 100 levels of ROI
- 🛡️ **CertiK Audited** — Professional security review
- 🔒 **Ownership Renounced** — No admin can touch your funds
- 🏛️ **UK Registered** — IMP MONEY LTD (Company No: 16926268)

---

## Smart Contracts

Both contracts are deployed on BNB Smart Chain with **verified source code** and **renounced ownership**.

### ImpVaultV7

The liquidity vault that holds all funds in a PancakeSwap V3 USDT/USDC concentrated liquidity position.

| Property | Value |
|----------|-------|
| **Address** | [`0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C`](https://bscscan.com/address/0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C#code) |
| **Status** | 🔒 Immutable |
| **Admin Functions** | None |

### ImpTreasuryV7

The treasury contract that manages deposits, withdrawals, referrals, and rank bonuses.

| Property | Value |
|----------|-------|
| **Address** | [`0x69077f02A721d2EC2548DAeA35d96B5481165Dd0`](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#readProxyContract) |
| **Owner** | `0x0000...0000` (Renounced) |
| **Upgradeable** | No (owner = 0x0) |

---

## Security

### CertiK Audit
All smart contracts have been audited by CertiK. View the full report:
- 🔗 [CertiK Skynet](https://skynet.certik.com/projects/imp-money)

### Ownership Renounced
Contract ownership has been permanently renounced to `0x0000000000000000000000000000000000000000`:
- ❌ No one can upgrade the contracts
- ❌ No one can pause deposits/withdrawals
- ❌ No one can change rates or rules
- ❌ No one can freeze or access user funds
- ✅ Code runs autonomously forever

### Deployer Private Key Published
For ultimate transparency, the deployer wallet private key is **publicly published**. Since ownership is renounced, this key has zero power over the contracts.

- **Deployer**: `0x1044EF645dC6d6Cb6636048f25D4Db3b98Ddcd13`

---

## Protocol Parameters

Constants hardcoded in the contracts (cannot be changed):

```solidity
uint256 public constant LOCK_PERIOD = 21 days;
uint256 public constant DAILY_RATE_BPS = 70;  // 0.7%
address public constant VAULT = 0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C;
```

---

## How It Works

```
User Deposits USDT
        ↓
Vault Adds to PancakeSwap V3 LP
        ↓
Trading Volume Generates Fees
        ↓
User Earns 0.7% Daily
        ↓
Claim Anytime / Withdraw After 21 Days
```

---

## Repository Structure

```
├── contracts/
│   ├── ImpVaultV7.sol       # Liquidity vault
│   └── ImpTreasuryV7.sol    # Treasury & referrals
├── docs/                     # GitBook documentation
│   ├── README.md
│   ├── SUMMARY.md
│   ├── getting-started/
│   ├── yield/
│   ├── referrals/
│   ├── leadership/
│   ├── contracts/
│   ├── faq/
│   └── resources/
└── README.md
```

---

## Documentation

Full documentation available at: **[docs.imp.money](https://docs.imp.money)**

- [Getting Started](docs/getting-started/what-is-imp-money.md)
- [3 Ways to Earn](docs/getting-started/three-ways-to-earn.md)
- [BSCScan Withdrawal Guide](docs/getting-started/bscscan-withdrawal.md)
- [Team Building Guide](docs/referrals/team-building-guide.md)
- [Contract Security](docs/contracts/security.md)

---

## Links

| Resource | Link |
|----------|------|
| 🌐 Website | [imp.money](https://imp.money) |
| 📚 Documentation | [docs.imp.money](https://docs.imp.money) |
| 📱 Telegram Community | [t.me/impmoneychat](https://t.me/impmoneychat) |
| 📢 Telegram Announcements | [t.me/officialimpmoney](https://t.me/officialimpmoney) |
| 🐦 Twitter/X | [x.com/impmoneyproject](https://x.com/impmoneyproject) |
| 📺 YouTube | [youtube.com/@theimpmoney](https://www.youtube.com/@theimpmoney) |
| 🛡️ CertiK Audit | [skynet.certik.com](https://skynet.certik.com/projects/imp-money) |
| 📊 BSCScan (Vault) | [View Contract](https://bscscan.com/address/0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C) |
| 📊 BSCScan (Treasury) | [View Contract](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0) |

---

## Company

**IMP MONEY LTD**
- UK Company Number: 16926268
- Registered in England & Wales

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Built for the community. Verified on-chain. Trustless by design.**

</div>
