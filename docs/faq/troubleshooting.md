# Troubleshooting

Solutions to common issues with IMP Money.

## Wallet Connection

### Wallet won't connect
1. **Refresh the page** and try again
2. **Clear browser cache** (Ctrl+Shift+Delete)
3. **Try different browser** (Chrome recommended)
4. **Update wallet extension** to latest version
5. **Disable other wallet extensions** (conflicts)

### "Wrong Network" error
1. Open your wallet
2. Switch to BNB Smart Chain
3. If BSC isn't added, use these settings:
   - Network: BNB Smart Chain
   - RPC: https://bsc-dataseed.binance.org
   - Chain ID: 56
   - Symbol: BNB

### Connection keeps dropping
- Disable VPN temporarily
- Try mobile wallet with WalletConnect
- Check internet stability

## Deposits

### "Insufficient funds for gas"
You need BNB for transaction fees:
1. Buy BNB on an exchange
2. Withdraw to your wallet (BEP20 network!)
3. ~$2-5 is enough for many transactions

### "Execution reverted" error
Common causes:
- **Insufficient USDT balance** - Check your balance
- **Not enough allowance** - Approve first, then deposit
- **Below minimum** - Minimum is $10 USDT
- **Contract paused** - Rare, check Telegram for announcements

### Transaction stuck pending
1. Wait 10-15 minutes (network congestion)
2. Check gas price isn't too low
3. Use "Speed Up" in MetaMask if available
4. Or wait for it to fail and retry

### Deposit not showing in dashboard
1. Wait a few minutes and refresh
2. Verify transaction succeeded on BSCScan
3. Ensure you're connected with correct wallet
4. Clear cache and reconnect

## Claims & Withdrawals

### "Nothing to claim"
- ROI accrues over time - wait at least a few hours
- Verify you have an active deposit
- Check dashboard for claimable amount

### Can't withdraw - says "locked"
Your deposit is locked for 21 days. Check:
- Deposit date on your dashboard
- Days remaining until unlock
- Profits are still claimable during lock

### Withdrawal succeeded but no USDT received
1. Check transaction on BSCScan - was it successful?
2. Add USDT token to your wallet manually
3. Token: `0x55d398326f99059fF775485246999027B3197955`

## Referrals

### Referral link not tracking
- Ensure link format is correct: `imp.money?ref=0xYourAddress`
- Cookie may have expired - person should click link again
- They may have used someone else's link after yours

### Commission not received
1. Verify you had active deposit when they deposited
2. Check you had necessary levels unlocked
3. Look for small transactions on BSCScan
4. Contact support with their tx hash

### Network not showing updates
Dashboard may cache. Try:
- Hard refresh (Ctrl+F5)
- Wait a few minutes
- Disconnect and reconnect wallet

## Mobile Issues

### Page not loading properly
- Use Chrome or Safari browser
- Enable JavaScript
- Disable ad blockers
- Try desktop mode in browser settings

### MetaMask mobile issues
- Update app to latest version
- Use in-app browser (MetaMask browser)
- Clear app cache

### Trust Wallet not connecting
- Use WalletConnect option
- Or use Trust Wallet's built-in browser
- Navigate to imp.money from there

## Still Need Help?

Join our Telegram community for support:
- **[t.me/impmoneychat](https://t.me/impmoneychat)**

When asking for help:
- Describe the issue clearly
- Include error messages
- Share transaction hashes (not private keys!)
- Mention your browser/wallet

{% hint style="danger" %}
**Beware of scammers!** Admins will NEVER:
- DM you first
- Ask for seed phrases
- Ask for funds
- Ask you to "validate" wallet
{% endhint %}

---

→ [General FAQ](general.md)
→ [Deposits & Withdrawals FAQ](deposits-withdrawals.md)
