// lib/providers/cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../models/laptop.dart';
import '../models/cart_items.dart';

class CartNotifier extends StateNotifier<Cart> {
  CartNotifier() : super(Cart());

  void addItem(Laptop laptop) {
    state = state.copyWith(
      items: {...state.items}..update(
        laptop.productId,
        (existingItem) => CartItem(
          laptop: laptop,
          quantity: existingItem.quantity + 1,
        ),
        ifAbsent: () => CartItem(
          laptop: laptop,
          quantity: 1,
        ),
      ),
    );
  }

  void removeItem(String productId) {
    final updatedItems = {...state.items};
    updatedItems.remove(productId);
    state = state.copyWith(items: updatedItems);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    
    state = state.copyWith(
      items: {...state.items}..update(
        productId,
        (existingItem) => CartItem(
          laptop: existingItem.laptop,
          quantity: quantity,
        ),
      ),
    );
  }

  void clear() {
    state = Cart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, Cart>((ref) {
  return CartNotifier();
});