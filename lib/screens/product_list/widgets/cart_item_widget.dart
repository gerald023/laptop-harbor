import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/cart_items.dart';
import '../../../models/cart.dart';

class CartItemWidget extends StatelessWidget {
  final String productId;
  final CartItem cartItem;

  CartItemWidget({
    required this.productId,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
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
                  Text('Quantity: '),
                  IconButton(
                    icon: Icon(Icons.remove, size: 18),
                    onPressed: cartItem.quantity > 1
                        ? () {
                            cart.updateQuantity(productId, cartItem.quantity - 1);
                          }
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text('${cartItem.quantity}'),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 18),
                    onPressed: () {
                      cart.updateQuantity(productId, cartItem.quantity + 1);
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Remove Item'),
                      content: Text('Are you sure you want to remove this item from the cart?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () {
                            cart.removeItem(productId);
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