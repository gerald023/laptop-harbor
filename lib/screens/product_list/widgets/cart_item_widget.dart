import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/cart_items.dart';
import '../../../provider/cart_provider.dart';

class CartItemWidget extends ConsumerWidget {
  final String productId;
  final CartItem cartItem;

  const CartItemWidget({
    Key? key,
    required this.productId,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(cartItem.laptop.displayImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(cartItem.laptop.productName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: \$${cartItem.laptop.discountedPrice.toStringAsFixed(2)}'),
              Row(
                children: [
                  const Text('Quantity: '),
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: cartItem.quantity > 1
                        ? () {
                            cartNotifier.updateQuantity(productId, cartItem.quantity - 1);
                          }
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text('${cartItem.quantity}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {
                      cartNotifier.updateQuantity(productId, cartItem.quantity + 1);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${(cartItem.laptop.discountedPrice * cartItem.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Remove Item'),
                      content: const Text('Are you sure you want to remove this item from the cart?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            cartNotifier.removeItem(productId);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}