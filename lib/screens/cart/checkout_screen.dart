import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aptech_project/models/transaction_model.dart'; // Assume your TransactionModel and MyTransactionStatus are here

class CheckoutForm extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final TransactionModel transaction;
  final void Function()? onPay;

  const CheckoutForm({
    super.key,
    required this.cartItems,
    required this.transaction,
    this.onPay,
  });

  // int get totalItems => cartItems.fold(0, (sum, item) => sum + (item['quantity'] ?? 1));
  // double get totalAmount => cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: transaction.currency);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Checkout Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),
            // _buildSummaryRow('Total Items:', totalItems.toString()),
            // _buildSummaryRow('Total Amount:', currencyFormatter.format(totalAmount)),
            _buildSummaryRow('Payment Method:', transaction.paymentMethod),
            _buildSummaryRow('Currency:', transaction.currency),
            _buildSummaryRow('Description:', transaction.description),
            _buildSummaryRow('Status:', transaction.status!.value.toUpperCase()),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPay,
                icon: const Icon(Icons.payment),
                label: const Text('Proceed to Pay'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}
