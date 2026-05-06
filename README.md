# Foundry FundMe

A decentralized crowdfunding protocol built with Foundry. This project allows users to fund a contract with ETH based on a minimum USD value, and allows the owner to withdraw the funds.

## Features

- **Decentralized Funding**: Anyone can fund the contract with a minimum of $5 USD worth of ETH.
- **Chainlink Price Feeds**: Uses Chainlink Oracles to get real-time ETH/USD price data.
- **Multi-Network Support**: Seamlessly deploy to Anvil (local), Sepolia (testnet), or Mainnet using `HelperConfig`.
- **Gas Optimized**: Implements `cheaperWithdraw` pattern to minimize storage reads and save gas.
- **Robust Testing**: Comprehensive unit tests covering funding, security, and withdrawals.

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Foundry](https://getfoundry.sh/)

### Installation

```bash
git clone https://github.com/YOUR_USERNAME/foundry-FundMe
cd foundry-FundMe
forge install
forge build
```

## Usage

### Testing

Run the full test suite:
```bash
forge test
```

For more detailed traces:
```bash
forge test -vvv
```

### Deployment

#### Local (Anvil)
```bash
# Start anvil in a separate terminal
anvil

# Deploy
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
```

#### Testnet (Sepolia)
Make sure you have an `.env` file with `SEPOLIA_RPC_URL` and `PRIVATE_KEY`.
```bash
source .env
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --broadcast --private-key $PRIVATE_KEY --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Project Structure

- `src/`: Core smart contracts (`FundMe.sol`, `PriceConverter.sol`).
- `script/`: Deployment and configuration scripts (`DeployFundMe.s.sol`, `HelperConfig.s.sol`).
- `test/`: Unit tests (`FundMe.t.sol`).
- `lib/`: External dependencies (Chainlink, Forge Standard Library).

## Professional Patterns Applied

- **Naming Conventions**: 
    - `s_` for storage variables.
    - `i_` for immutable variables.
    - `FundMe__` prefix for custom errors.
- **Gas Optimization**: Memory arrays used in `cheaperWithdraw` to reduce SLOAD operations.
- **Multi-Chain Orchestration**: `HelperConfig` abstracts network-specific parameters (Price Feed addresses) and handles mock deployments for local testing.

## Acknowledgments

Inspired by the Cyfrin / Patrick Collins Foundry Course.

## License

MIT
