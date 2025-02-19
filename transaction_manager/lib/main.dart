import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:transaction_manager/services/web3_service.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExpenseManagerScreen(),
    );
  }
}

class ExpenseManagerScreen extends StatefulWidget {
  @override
  _ExpenseManagerScreenState createState() => _ExpenseManagerScreenState();
}

class _ExpenseManagerScreenState extends State<ExpenseManagerScreen> {
  late Web3Service web3Service;
  String balance = "Load...";
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    web3Service = Web3Service();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    try {
      log("Fetching balance...");
      BigInt fetchedBalance = await web3Service
          .getBalance("0x52c24faEbc29004DC71B731CC1e49068644196Cc");
      log("Balance fetched: $fetchedBalance");
      double _fetchedBalance = fetchedBalance.toDouble() / 1000000000000000000;
      setState(() {
        balance = "$_fetchedBalance ETH";
      });
    } catch (e) {
      log("Error fetching balance: $e");
      setState(() {
        balance = "Error";
      });
    }
  }

  Future<void> _deposit() async {
    String reason = reasonController.text.trim();
    String amountText = amountController.text.trim();

    log("Deposit Input - Reason: '$reason', Amount: '$amountText'");

    if (amountText.isEmpty) {
      log("Error: Amount field is empty");
      return;
    }

    try {
      BigInt amount =
          BigInt.from(double.parse(amountText) * 1000000000000000000);
      String txHash = await web3Service.deposit(reason, amount);
      log("Transaction Hash: $txHash");
      _fetchBalance();
    } catch (e) {
      log("Deposit Error: Invalid input - $e");
    }
  }

  Future<void> _withdraw() async {
    String reason = reasonController.text.trim();
    String amountText = amountController.text.trim();

    log("Withdraw Input - Reason: '$reason', Amount: '$amountText'");

    if (amountText.isEmpty) {
      log("Error: Amount field is empty");
      return;
    }

    try {
      // Convert string to double first, then scale up to BigInt
      double amountDouble = double.parse(amountText);
      BigInt amount = BigInt.from(amountDouble * 1e18);

      String txHash = await web3Service.withdraw(amount, reason);
      log("Transaction Hash: $txHash");
      _fetchBalance();
    } catch (e) {
      log("Withdraw Error: Invalid input - $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 17,
          children: [
            Text("Balance: $balance",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
                controller: reasonController,
                decoration: InputDecoration(labelText: "Reason")),
            TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Amount in ETH"),
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _deposit, child: Text("Deposit")),
                ElevatedButton(onPressed: _withdraw, child: Text("Withdraw")),
              ],
            ),
            ElevatedButton(
                onPressed: _fetchBalance, child: Text("Fetchbalance")),
          ],
        ),
      ),
    );
  }
}
