# IMP Protocol - $MONEY Token & Vault System 🚀

## Overview

IMP Protocol is a decentralized finance (DeFi) system built on Binance Smart Chain (BSC) that provides automated liquidity management through advanced vault strategies. 

- **ImpVault**: Automated liquidity management vault for PancakeSwap V3

## 🏗️ Smart Contracts

### ImpVaultPublic.sol  
The public vault contract that manages user deposits and liquidity provision on PancakeSwap V3. Features:
- **Automated Position Management**: Optimizes liquidity ranges for maximum efficiency
- **Compound Rewards**: Auto-compounds fees back into positions
- **Emergency Controls**: Safety mechanisms for user protection
- **No Lock-up Period**: Users can withdraw anytime
- **Protocol Fee**: Small fee for sustainability

## 📊 Deployment Information

Key addresses:
- **ImpVault**: `0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C`
- **USDT**: `0x55d398326f99059fF775485246999027B3197955` (BSC USDT)

### Verified on BSCScan
All contracts are verified and open-source. You can view the source code directly on BSCScan.

## 💰 How It Works

1. **Deposit**: Users deposit USDT into the vault
2. **Liquidity Provision**: Vault creates optimized positions on PancakeSwap V3
3. **Fee Generation**: Positions earn trading fees from the DEX
5. **Compound**: Fees are automatically reinvested

## 🔒 Security Features

- **Audited Contracts**: Professional security audits completed
- **Ownership Renounced**: Contracts are immutable after deployment
- **Emergency Pause**: Circuit breaker for user protection
- **Transparent Operations**: All transactions visible on-chain

## 🛠️ Technical Stack

- **Blockchain**: Binance Smart Chain (BSC)
- **DEX Integration**: PancakeSwap V3
- **Language**: Solidity ^0.8.19
- **Framework**: Hardhat
- **Testing**: Comprehensive test coverage

## 📈 Vault Strategy

The vault implements sophisticated strategies to maximize returns:

- **Dynamic Range Adjustment**: Adapts to market conditions
- **Fee Tier Optimization**: Selects optimal fee tiers
- **Impermanent Loss Mitigation**: Strategic position management
- **Auto-Compounding**: Maximizes APY through frequent compounding
