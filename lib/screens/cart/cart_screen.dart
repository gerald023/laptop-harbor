import 'package:aptech_project/services/product_services.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void updateQuantity(String id, int change) {
    ProductService().increaseCartQauntity(id, change);
  }

  void checkout(BuildContext context) async {
    await ProductService.checkout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: StreamBuilder(
        stream: ProductService.getCartStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final cartItems = snapshot.data!.docs;
          double total = 0;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: cartItems.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    total += data['price'] * data['quantity'];
                    return ListTile(
                      leading: Image.network(data['image']),
                      title: Text(data['name']),
                      subtitle: Text('\$${data['price']} x ${data['quantity']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.remove), onPressed: () => updateQuantity(doc.id, -1)),
                          IconButton(icon: const Icon(Icons.add), onPressed: () => updateQuantity(doc.id, 1)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total: \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => checkout(context),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
