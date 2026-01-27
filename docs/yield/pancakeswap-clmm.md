# PancakeSwap V3 CLMM

IMP Money generates yield through Concentrated Liquidity Market Making (CLMM) on PancakeSwap V3.

## What is CLMM?

**Concentrated Liquidity** allows liquidity providers to focus their capital within specific price ranges, rather than spreading it across the entire price curve.

### Traditional AMM (V2)
```
Capital distributed: $0.01 ------------- $∞
Efficiency: Low
```

### Concentrated Liquidity (V3)
```
Capital concentrated: $0.999 --- $1.001
Efficiency: Up to 4000x higher!
```

## Why Stablecoins?

IMP Money focuses on **USDT/USDC pairs** for several reasons:

### 1. Predictable Range
- Stablecoins trade near 1:1
- Tight range = maximum capital efficiency
- Minimal impermanent loss

### 2. High Volume
- USDT/USDC is one of the highest-volume pairs
- More trades = more fees collected
- Consistent fee generation

### 3. Low Risk
- No volatile asset exposure
- Minimal price risk
- Predictable returns

## How Fees Are Generated

```
Trader swaps USDT → USDC
        ↓
Pays 0.01% fee
        ↓
Fee distributed to LP
        ↓
IMP Vault receives share
        ↓
You receive 0.7% daily
```

## Capital Efficiency Example

**$1,000 in Traditional V2:**
- Spread across infinite range
- Only ~$10 actively earning at any time

**$1,000 in V3 Concentrated:**
- Focused in 0.9990-1.0010 range
- Full $1,000 actively earning
- 100x more efficient

## PancakeSwap V3 on BSC

PancakeSwap is the leading DEX on BNB Smart Chain:

| Metric | Value |
|--------|-------|
| TVL | $1B+ |
| Daily Volume | $500M+ |
| Trading Fees | 0.01% - 0.25% |
| Chains | BSC, Ethereum, more |

## Security of LP Position

Your funds in PancakeSwap V3:
- Held in audited smart contracts
- Non-custodial
- Battle-tested with billions in TVL
- No admin keys can steal funds

## Why 0.7% is Sustainable

The math for concentrated stablecoin LP:

1. **Volume**: $100M daily on USDT/USDC pairs
2. **Fee rate**: 0.01% = $10,000 daily fees
3. **TVL in range**: $5M concentrated
4. **Daily yield**: $10,000 / $5M = 0.2%
5. **With 3x concentration**: 0.6%+
6. **Plus arbitrage opportunities**: 0.7%+ achievable

## Learn More

- [PancakeSwap Docs](https://docs.pancakeswap.finance/)
- [Uniswap V3 Whitepaper](https://uniswap.org/whitepaper-v3.pdf) (original CLMM design)

---

→ [How ROI Works](how-roi-works.md)
→ [21-Day Cycles](cycles.md)
