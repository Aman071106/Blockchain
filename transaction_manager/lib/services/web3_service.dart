import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:developer';

class Web3Service {
  late Web3Client web3client;
  late DeployedContract contract;
  late EthereumAddress ownAddress;
  late Credentials credentials;

  final String rpcUrl =
      "https://sepolia.infura.io/v3/YOUR-INFURA-APIKEY"; // Update this
  final String privateKey =
      "PRIVATE-KEY OF WALLET"; // Use ENV Variables, DO NOT Hardcode

  Web3Service() {
    _initialize();
  }

  Future<void> _initialize() async {
    web3client = Web3Client(rpcUrl, Client());
    credentials = EthPrivateKey.fromHex(privateKey);
    ownAddress = await credentials.extractAddress();

    String abi = await rootBundle.loadString("assets/ExpenseManagerABI.json");
    EthereumAddress contractAddress =
        EthereumAddress.fromHex("0x27a8372d8A81de50634ecB68f1Da720a3d24f61f");

    contract = DeployedContract(
      ContractAbi.fromJson(abi, "ExpenseManagerContract"),
      contractAddress,
    );

    log("Contract Initialized: ${contract.address}");
  }

  Future<BigInt> getBalance(String address) async {
    try {
      log("Fetching balance...");
      final result = await web3client.call(
        contract: contract,
        function: contract.function("getBalance"),
        params: [EthereumAddress.fromHex(address)],
      );
      return result.first as BigInt;
    } catch (e) {
      log("Error fetching balance: $e");
      return BigInt.zero;
    }
  }

  Future<String> deposit(String reason, BigInt amount) async {
    try {
      final function = contract.function("deposit");
      final txHash = await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [reason, amount],
        ),
        chainId: 11155111, // Sepolia Testnet
      );
      log("Deposit Transaction Hash: $txHash");
      return txHash;
    } catch (e) {
      log("Deposit Error: $e");
      return "";
    }
  }

  Future<String> withdraw(BigInt amount, String reason) async {
    try {
      final function = contract.function("withdraw");
      final txHash = await web3client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [amount, reason],
        ),
        chainId: 11155111,
      );
      log("Withdraw Transaction Hash: $txHash");
      return txHash;
    } catch (e) {
      log("Withdraw Error: $e");
      return "";
    }
  }
}
