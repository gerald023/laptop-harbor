import 'package:aptech_project/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../services/transactions_service.dart'; // Import the service class you created

class FundAccountScreen extends StatefulWidget {
  final String accountId;

  const FundAccountScreen({
    super.key,
    required this.accountId,
  });

  @override
  State<FundAccountScreen> createState() => _FundAccountScreenState();
}

class _FundAccountScreenState extends State<FundAccountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _txnTokenController = TextEditingController();
  final TextEditingController _midController = TextEditingController(text: "YourMerchantId");
  final bool isStaging = true;

  bool _isProcessing = false;
  final dummyTransaction = TransactionModel(
  amount: 1000.0,
  purpose: 'wallet_funding',
  status: MyTransactionStatus.pending,
  timestamp: DateTime.now(),
  paymentMethod: 'manual',
  reference: 'REF123456',
  currency: 'USD',
  description: 'User funded wallet',
  isRefunded: false,
  metadata: {'source': 'dummy'},
);
  Future<void> _startFunding() async {
    final amount = _amountController.text.trim();
    final txnToken = _txnTokenController.text.trim();
    final mid = _midController.text.trim();

    if (amount.isEmpty || txnToken.isEmpty || mid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // final orderId = "ORDER_${const Uuid().v4().substring(0, 8)}";

    setState(() => _isProcessing = true);

    try {
      bool res = await TransactionService().handleTransactions(dummyTransaction);

      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account funded successfully!')),
      );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account not funded')),
      );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fund Wallet with Paytm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (INR)',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _txnTokenController,
              decoration: InputDecoration(
                labelText: 'Transaction Token',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _midController,
              decoration: InputDecoration(
                labelText: 'Merchant ID (MID)',
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isProcessing ? null : _startFunding,
              child: _isProcessing
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Fund Account'),
            ),
          ],
        ),
      ),
    );
  }
}
