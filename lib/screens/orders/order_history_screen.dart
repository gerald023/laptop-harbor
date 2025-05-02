import 'package:aptech_project/route/screen_export.dart';
import 'package:flutter/material.dart';
import 'package:aptech_project/services/transactions_service.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
Widget build(BuildContext context) {
  return FutureBuilder(
    future: TransactionService().getUserOrders(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return const Center(child: Text('Something went wrong.'));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const EmptyOrderHistoryScreen();
      }

      final orders = snapshot.data!;
      return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            title: Text('Order ID: ${order.orderId}'),
            subtitle: Text('Total: \$${order.cart.totalPrice}'),
            // onTap: () => Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => OrderDetailsScreen(orderId: order.orderId),
            //   ),
            // ),
          );
        },
      );
    },
  );
}

}