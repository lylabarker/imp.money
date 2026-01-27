# Offline Withdrawal Guide (BSCScan)

If the website is ever unavailable, you can interact with IMP Money smart contracts directly through BSCScan. Your funds are **always accessible** through the blockchain.

{% hint style="success" %}
This is the power of decentralization — you don't depend on any website to access your funds!
{% endhint %}

## Prerequisites

- A Web3 wallet (MetaMask recommended)
- Some BNB for gas fees (~$0.20)
- Your wallet connected to BSCScan

## Step 1: Connect Wallet to BSCScan

1. Go to BSCScan: [bscscan.com](https://bscscan.com)
2. Click **"Connect to Web3"** (top right, near search bar)
3. Select **MetaMask** (or your wallet)
4. Approve the connection in your wallet
5. Ensure you're on **BNB Smart Chain**

## Step 2: Go to the Treasury Contract

Navigate to the ImpTreasuryV7 contract:

**[https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#writeProxyContract](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#writeProxyContract)**

Click on **"Write as Proxy"** tab.

## Step 3: Find Your Deposit ID

Before withdrawing, you need your deposit ID:

1. Go to **"Read as Proxy"** tab first: [Read Contract](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0#readProxyContract)
2. Find function: `getUserDeposits`
3. Enter your wallet address
4. Click **"Query"**
5. Note your deposit IDs (usually starts from 0)

Or find function `getDepositInfo` and enter your address + deposit ID to see details:
- Amount
- Start time
- Claimed yield

## Step 4: Claim Yield (Anytime)

To claim your accrued ROI:

1. Go to **"Write as Proxy"** tab
2. Find function: `claimYield`
3. Enter your **depositId** (number from Step 3)
4. Click **"Write"**
5. Confirm the transaction in your wallet
6. Wait for confirmation (~3-15 seconds)

Your yield will be sent to your wallet as USDT.

## Step 5: Withdraw Principal (After 21 Days)

To withdraw your full deposit after the lock period:

1. Go to **"Write as Proxy"** tab
2. Find function: `withdraw`
3. Enter your **depositId**
4. Click **"Write"**
5. Confirm the transaction in your wallet
6. Wait for confirmation

You'll receive your principal + any remaining unclaimed yield.

{% hint style="warning" %}
**Important**: You can only withdraw after 21 days from your deposit date. Before that, only `claimYield` will work.
{% endhint %}

## Step 6: Claim Referral Rewards

To claim your referral commissions and rank bonuses:

1. Find function: `claimRewards`
2. Click **"Write"** (no parameters needed)
3. Confirm in wallet

All accumulated rewards are sent to your wallet.

## Step 7: Compound (Optional)

To reinvest your rewards as a new deposit:

1. Find function: `compound`
2. Click **"Write"**
3. Confirm in wallet

Your rewards become a new deposit, starting a fresh 21-day cycle.

## Contract Functions Reference

### Write Functions (Actions)

| Function | Purpose | Parameters |
|----------|---------|------------|
| `claimYield(depositId)` | Claim ROI | depositId (number) |
| `withdraw(depositId)` | Withdraw after 21 days | depositId (number) |
| `claimRewards()` | Claim ref + rank rewards | none |
| `compound()` | Reinvest rewards | none |

### Read Functions (View Data)

| Function | Returns | Parameters |
|----------|---------|------------|
| `getUserDeposits(address)` | Your deposit IDs | your wallet address |
| `getDepositInfo(address, id)` | Deposit details | address, depositId |
| `pendingYield(address, id)` | Claimable yield | address, depositId |
| `pendingRewards(address)` | Claimable rewards | your wallet address |
| `getUserInfo(address)` | Your full profile | your wallet address |

## Troubleshooting

### "Execution Reverted"
- **For withdraw**: Lock period not ended (need 21 days)
- **For claimYield**: No yield available
- **Check gas**: Make sure you have BNB

### "User Rejected"
You cancelled in your wallet. Try again and confirm.

### Transaction Stuck
- Wait 10-15 minutes
- Use "Speed Up" in MetaMask
- Try with higher gas

### Can't Find Deposit ID
- `getUserDeposits` returns an array of IDs
- First deposit is usually ID 0
- Second deposit is ID 1, etc.

## Video Tutorial

For visual learners, search "BSCScan write contract" on YouTube for general tutorials on interacting with smart contracts.

## Important Contract Addresses

Keep these saved for reference:

```
Treasury:  0x69077f02A721d2EC2548DAeA35d96B5481165Dd0
Vault:     0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C
USDT:      0x55d398326f99059fF775485246999027B3197955
```

---

→ [Withdrawing (via website)](withdrawing.md)
→ [Troubleshooting](../faq/troubleshooting.md)
