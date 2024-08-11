
```markdown
# Foundry Fund Me

This repository provides the codebase for deploying and interacting with a smart contract that allows users to fund and withdraw funds. It leverages Foundry and zkSync for testing and deployment on local and test networks. 

SEPOLIA DEPLOYMENT ADDRESS: 0xea7C0294FF4DE9aeCa8772cAd31adAEcd5d95d59

## Getting Started

### Requirements

- **Git**  
  You'll know it's installed correctly if you can run `git --version` and see a response like `git version x.x.x`.

- **Foundry**  
  You'll know it's installed correctly if you can run `forge --version` and see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`.

### Quickstart

1. Clone the repository:

   ```bash
   git clone https://github.com/Cyfrin/foundry-fund-me-cu
   ```

2. Navigate into the project directory:

   ```bash
   cd foundry-fund-me-cu
   ```

3. Build the project:

   ```bash
   make
   ```

### Optional: Gitpod

If you can't or don't want to run and install locally, you can work with this repo in Gitpod. If you do this, you can skip the `git clone` step.

[Open in Gitpod](https://gitpod.io/#https://github.com/kennisnutz/foundry-fund-me-cu)

## Usage

### Deploy

To deploy the contract:

```bash
forge script script/DeployFundMe.s.sol
```

### Testing

This repository includes tests categorized into four tiers:

1. Unit
2. Integration
3. Forked
4. Staging

In this repo, we cover **Unit** and **Forked** tests. To run the tests:

```bash
forge test
```

You can also run specific tests using:

```bash
forge test --match-test testFunctionName
```

Or run tests on a forked network:

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

To check the test coverage:

```bash
forge coverage
```

## Local zkSync

These instructions allow you to work with this repo on zkSync.

### Additional Requirements

In addition to the above, you'll need:

- **Foundry-zksync**  
  You'll know it's installed correctly if you can run `forge --version` and see a response like `forge 0.0.2 (816e00b 2023-03-16T00:05:26.396218Z)`.

- **npx & npm**  
  You'll know they're installed correctly if you can run `npm --version` and see a response like `7.24.0` and `npx --version` with a response like `8.1.0`.

- **Docker**  
  You'll know it's installed correctly if you can run `docker --version` and see a response like `Docker version 20.10.7, build f0df350`. The Docker daemon should be running; check with `docker --info`.

### Setup local zkSync node

1. Configure the zkSync node:

   ```bash
   npx zksync-cli dev config
   ```

   Select "In memory node" and do not select any additional modules.

2. Start the zkSync node:

   ```bash
   npx zksync-cli dev start
   ```

   You should see an output like:

   ```
   In memory node started v0.1.0-alpha.22:
    - zkSync Node (L2):
     - Chain ID: 260
     - RPC URL: http://127.0.0.1:8011
     - Rich accounts: https://era.zksync.io/docs/tools/testing/era-test-node.html#use-pre-configured-rich-wallets
   ```

### Deploy to local zkSync node

To deploy to the zkSync node:

```bash
make deploy-zk
```

This will deploy a mock price feed and a fund me contract to the zkSync node.

## Deployment to a Testnet or Mainnet

### Setup Environment Variables

Set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- **PRIVATE_KEY**: The private key of your account (e.g., from MetaMask). **NOTE: FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.**
- **SEPOLIA_RPC_URL**: The URL of the Sepolia testnet node you're working with. You can set up one for free from Alchemy.
- Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on Etherscan.

### Get Testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) to get some testnet ETH. You should see the ETH show up in your MetaMask.

### Deploy

Deploy your contract with the following command:

```bash
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Scripts

After deploying to a testnet or local net, you can run the following scripts:

- Fund the contract:

  ```bash
  cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
  ```

- Interact with the contract:

  ```bash
  forge script script/Interactions.s.sol:FundFundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
  forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
  ```

- Withdraw funds:

  ```bash
  cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --private-key <PRIVATE_KEY>
  ```

### Estimate Gas

To estimate how much gas transactions will cost:

```bash
forge snapshot
```

This will generate a `.gas-snapshot` file.

### Formatting

To format the code:

```bash
forge fmt
```

## Additional Information

### Chainlink-Brownie-Contracts

Some users have been confused about whether `chainlink-brownie-contracts` is an official Chainlink repository. It is indeed an official repo owned and maintained by the Chainlink team. It follows the proper Chainlink release process, and releases can be found under the `smartcontractkit` organization.

#### What "Official" Means

The "official" release process is that Chainlink deploys its packages to npm. Downloading directly from `smartcontractkit/chainlink` could use unreleased code. Therefore, it's recommended to:

1. Download from npm to ensure dependencies are compatible with Foundry.
2. Or, download from the `chainlink-brownie-contracts` repo, which packages everything neatly for Foundry.

In summary, `chainlink-brownie-contracts` is an official repo maintained by the same organization. It packages dependencies from the official release cycle for easy use with Foundry.

## Thank You!

If you found this helpful, feel free to follow me or donate!

**ETH/Arbitrum/Optimism/Polygon/etc Address**: `0x4031cF9bd59913FCe8cb6C0b439b077d044E1E1F`
```