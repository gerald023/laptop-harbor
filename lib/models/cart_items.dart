import 'laptop.dart';

class CartItem {
  final Laptop laptop;
  int quantity;

  CartItem({
    required this.laptop,
    this.quantity = 1,
  });

  double get totalPrice => laptop.discountedPrice * quantity;
}