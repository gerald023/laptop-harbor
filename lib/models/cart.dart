// lib/models/cart.dart
import 'cart_items.dart';

class Cart {
  final Map<String, CartItem> items;

  Cart({
    this.items = const {},
  });

  int get itemCount {
    return items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return items.values.fold(0.0, (sum, item) => sum + (item.laptop.discountedPrice * item.quantity));
  }

  Cart copyWith({
    Map<String, CartItem>? items,
  }) {
    return Cart(
      items: items ?? this.items,
    );
  }
}