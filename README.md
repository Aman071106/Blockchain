# Hardhat Setup and Deployment Guide

## Prerequisites
Ensure you have the following installed:
- [Node.js](https://nodejs.org/) (LTS version recommended)
- [Hardhat](https://hardhat.org/)
- [Metamask](https://metamask.io/) (for interacting with the blockchain)
- A Sepolia testnet account with test ETH (for deployments)

## Step 1: Initialize Hardhat Project
Run the following commands:
```sh
mkdir my-hardhat-project
cd my-hardhat-project
npm init -y
npm install --save-dev hardhat
npx hardhat
```
Choose `Create a basic sample project` and follow the prompts.

## Step 2: Install Dependencies
```sh
npm install --save-dev @nomicfoundation/hardhat-toolbox dotenv ethers
```

## Step 3: Configure Hardhat
Edit `hardhat.config.js`:
```js
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
```

## Step 4: Set Up Environment Variables
Create a `.env` file and add:
```env
SEPOLIA_RPC_URL="https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_API_KEY"
PRIVATE_KEY="your-private-key"
```
Replace `YOUR_ALCHEMY_API_KEY` and `your-private-key` with actual values.

## Step 5: Write and Compile the Smart Contract
Create a `contracts/ExpenseManager.sol` file and define your Solidity contract.
Compile using:
```sh
npx hardhat compile
```

## Step 6: Deploy the Smart Contract
Create a `scripts/deploy.js` file:
```js
const hre = require("hardhat");

async function main() {
  const ExpenseManager = await hre.ethers.getContractFactory("ExpenseManager");
  const expenseManager = await ExpenseManager.deploy();
  await expenseManager.deployed();
  console.log("Contract deployed to:", expenseManager.address);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
```
Run the deployment script:
```sh
npx hardhat run scripts/deploy.js --network sepolia
```

## Step 7: Interact with the Contract in Flutter
Use the deployed contract address in your Flutter `web3_service.dart` file.

## Troubleshooting
- Ensure you have Sepolia test ETH in your account.
- Check that your `.env` variables are correct.
- If deployment fails, verify network settings in `hardhat.config.js`.

## Conclusion
This guide helps you set up Hardhat, deploy a smart contract, and integrate it into a Flutter application. 🎉


# Interacting with Smart Contract on Sepolia Testnet in Flutter

![Blockchain](https://upload.wikimedia.org/wikipedia/commons/6/6a/Ethereum-icon-purple.svg) ![Flutter](https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png) ![MetaMask](https://upload.wikimedia.org/wikipedia/en/3/36/MetaMask_Fox.svg) ![Infura](https://infura.io/img/share-thumbnail.png)

## Prerequisites
- ![Flutter](https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png) Flutter installed
- ![MetaMask](https://upload.wikimedia.org/wikipedia/en/3/36/MetaMask_Fox.svg) MetaMask wallet with Sepolia ETH
- ![Infura](https://infura.io/img/share-thumbnail.png) Infura project setup (API key)
- Deployed smart contract on Sepolia testnet
- Web3dart package for Flutter

## Skills Acquired
- Blockchain interaction
- Smart contract development
- Web3 integration with Flutter
- Secure key management
- Gas optimization
- API interaction with Infura

## Tools Used
- ![Remix](https://remix-project.org/assets/imgs/remix-logo.svg) **Remix** - Smart contract development
- ![Hardhat](https://hardhat.org/assets/img/hardhat-logo.svg) **Hardhat** - Ethereum development environment
- ![Infura](https://infura.io/img/share-thumbnail.png) **Infura** - Blockchain node provider
- ![Etherscan](https://etherscan.io/images/brandassets/etherscan-logo-circle.svg) **Etherscan** - Blockchain explorer
- ![Ethereum](https://upload.wikimedia.org/wikipedia/commons/6/6a/Ethereum-icon-purple.svg) **Blockchain** - Decentralized application infrastructure
- ![Solidity](https://upload.wikimedia.org/wikipedia/commons/9/98/Solidity_logo.svg) **Solidity** - Smart contract programming language

## Setup Infura
1. Go to [Infura](https://infura.io/)
2. Create a new project
3. Select Ethereum and get the Sepolia endpoint
4. Copy the Infura API URL (e.g., `https://sepolia.infura.io/v3/YOUR_PROJECT_ID`)

## Add Dependencies
In your `pubspec.yaml`, add:
```yaml
dependencies:
  web3dart: ^2.5.0
  http: ^0.13.0
  flutter_secure_storage: ^5.0.2
``` 
Run:
```sh
flutter pub get
```

## Connect to MetaMask
Use `flutter_secure_storage` to store private keys or use MetaMask's wallet connect feature.

## Load Contract
Create a `contract_service.dart` file:
```dart
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class ContractService {
  final String rpcUrl = "https://sepolia.infura.io/v3/YOUR_PROJECT_ID";
  final String privateKey = "YOUR_PRIVATE_KEY";
  final String contractAddress = "YOUR_CONTRACT_ADDRESS";
  Web3Client? _client;
  Credentials? _credentials;

  Future<void> init() async {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future<String> callFunction(String functionName, List<dynamic> args) async {
    final contract = DeployedContract(
      ContractAbi.fromJson("YOUR_ABI", "ContractName"),
      EthereumAddress.fromHex(contractAddress),
    );
    final function = contract.function(functionName);
    return _client!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: args,
      ),
    );
  }
}
```

## Read Data
```dart
Future<List<dynamic>> readData() async {
  final contract = DeployedContract(
    ContractAbi.fromJson("YOUR_ABI", "ContractName"),
    EthereumAddress.fromHex("YOUR_CONTRACT_ADDRESS"),
  );
  final function = contract.function("yourFunctionName");
  return await _client!.call(
    contract: contract,
    function: function,
    params: [],
  );
}
```

## Write Data
```dart
Future<String> writeData(String newValue) async {
  return await callFunction("yourFunctionName", [newValue]);
}
```

## Run the App
Make sure MetaMask is connected, and run:
```sh
flutter run
```

## Notes
- Always store private keys securely.
- MetaMask wallet connect can be integrated for better security.
- Check gas fees before transactions.

This README guides you through interacting with your contract on Sepolia using Flutter.