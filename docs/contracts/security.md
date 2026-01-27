# Security & Audits

Security is paramount at IMP Money. Our smart contracts have been audited by leading blockchain security firms and follow industry best practices.

## CertiK Audit

<figure><img src="../.gitbook/assets/certik-badge.png" alt=""><figcaption><p>CertiK Audited</p></figcaption></figure>

IMP Money has been audited by **CertiK**, one of the most respected blockchain security firms in the industry.

### Audit Details

| Property | Value |
|----------|-------|
| Auditor | CertiK |
| Status | ✅ Completed |
| Date | January 2026 |
| Scope | All smart contracts |
| Rating | Security Score Available |

### View Audit Report

🔗 [CertiK Security Report](https://skynet.certik.com/projects/imp-money)

### What CertiK Verified

- ✅ No critical vulnerabilities
- ✅ No high-severity issues
- ✅ Proper access controls
- ✅ Safe token handling
- ✅ Reentrancy protection
- ✅ Overflow/underflow protection

## Security Features

### 1. Non-Custodial Design

```
Your Wallet ←→ Smart Contract ←→ PancakeSwap

You always control your funds. No centralized custody.
```

### 2. Renounced Ownership

Both contracts have **renounced ownership**:
- No admin can modify core functions
- No one can steal user funds
- Contracts operate autonomously

Verify on BSCScan:
1. Go to [Treasury contract](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#readProxyContract)
2. Click "Read as Proxy"
3. Check `owner()` returns `0x0000000000000000000000000000000000000000`

### 3. Immutable Parameters

Key parameters are locked:
- 0.7% daily ROI rate
- 21-day lock period
- Referral commission rates
- Level unlock requirements

### 4. Verified Source Code

All contracts are:
- Verified on BSCScan
- Open source and readable
- Match deployed bytecode

### 5. Protected Functions

- **Reentrancy Guards** on all external calls
- **SafeERC20** for all token transfers
- **Access Control** on admin functions
- **Input Validation** on all parameters

## Best Practices We Follow

| Practice | Status |
|----------|--------|
| OpenZeppelin contracts | ✅ Used |
| Reentrancy protection | ✅ Implemented |
| Safe math operations | ✅ Solidity 0.8+ |
| Event emissions | ✅ All key actions |
| Pausable (emergency) | ✅ Available |
| Multi-sig operations | ✅ For upgrades |

## User Security Tips

### Protect Yourself

{% hint style="danger" %}
IMP Money will NEVER ask for your seed phrase or private keys!
{% endhint %}

- ✅ Only use official site: **imp.money**
- ✅ Verify contract addresses before interacting
- ✅ Use hardware wallet for large amounts
- ✅ Start with small test deposit
- ✅ Keep your wallet software updated
- ❌ Never share seed phrase
- ❌ Don't click suspicious links
- ❌ Ignore DMs offering "support"

### Verify Official Links

| Platform | Official Link |
|----------|--------------|
| Website | imp.money |
| Telegram | t.me/impmoneychat |
| CertiK | skynet.certik.com/projects/imp-money |

## Bug Bounty

Found a vulnerability? Contact us responsibly:

- Email: security@imp.money
- Telegram: @ImpMoneyAdmin
- Rewards available for valid findings

## Transparency

| Item | Location |
|------|----------|
| Contract Source | BSCScan (verified) |
| Audit Report | CertiK Skynet |
| TVL | Real-time on dashboard |
| Transactions | All on-chain |

---

→ [Contract Addresses](addresses.md)
→ [Renounced Ownership](renounced.md)
