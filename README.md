# IMP Protocol - $MONEY Token & Vault System 🚀

## Overview

IMP Protocol is a decentralized finance (DeFi) system built on Binance Smart Chain (BSC) that provides automated liquidity management through advanced vault strategies. The protocol consists of two main components:

- **$MONEY Token**: The native utility and reward token
- **ImpVault**: Automated liquidity management vault for PancakeSwap V3

## 🏗️ Smart Contracts

### MoneyToken.sol
The $MONEY token is an ERC20-compliant token with special minting capabilities reserved for the vault system. Key features:
- **Fixed Supply Cap**: 100,000,000 $MONEY tokens
- **Deflationary Mechanism**: Burn functionality for long-term value
- **Controlled Minting**: Only authorized vaults can mint rewards

### ImpVaultPublic.sol  
The public vault contract that manages user deposits and liquidity provision on PancakeSwap V3. Features:
- **Automated Position Management**: Optimizes liquidity ranges for maximum efficiency
- **Compound Rewards**: Auto-compounds fees back into positions
- **Emergency Controls**: Safety mechanisms for user protection
- **No Lock-up Period**: Users can withdraw anytime
- **Protocol Fee**: Small fee for sustainability

## 📊 Deployment Information

### Mainnet Contracts (BSC)
See `deployment_mainnet.json` for all verified contract addresses.

Key addresses:
- **$MONEY Token**: `0x0f99D3D2C45a8ee652e05E0b3c9D37Ef5d6A3e7d`
- **ImpVault**: `0xAe1e5Cb689c4309dE1cD849bc1ee6bF47c91ecD9`
- **USDT**: `0x55d398326f99059fF775485246999027B3197955` (BSC USDT)

### Verified on BSCScan
All contracts are verified and open-source. You can view the source code directly on BSCScan.

## 💰 How It Works

1. **Deposit**: Users deposit USDT into the vault
2. **Liquidity Provision**: Vault creates optimized positions on PancakeSwap V3
3. **Fee Generation**: Positions earn trading fees from the DEX
4. **Rewards**: Users receive $MONEY tokens as rewards
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
