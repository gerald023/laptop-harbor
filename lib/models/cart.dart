// lib/models/cart.dart
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'laptop.dart';
import 'cart_items.dart';

class Cart extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  UnmodifiableMapView<String, CartItem> get items => UnmodifiableMapView(_items);
  
  int get itemCount => _items.length;
  
  double get totalAmount {
    double total = 0;
    _items.forEach((key, item) {
      total += item.totalPrice;
    });
    return total;
  }

  void addItem(Laptop laptop, {int quantity = 1}) {
    if (_items.containsKey(laptop.productId)) {
      // Update quantity of existing item
      _items.update(
        laptop.productId,
        (existingItem) => CartItem(
          laptop: existingItem.laptop,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        laptop.productId,
        () => CartItem(
          laptop: laptop,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId) && quantity > 0) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          laptop: existingItem.laptop,
          quantity: quantity,
        ),
      );
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}