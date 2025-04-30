import 'package:aptech_project/models/cart_item_model.dart';

class CartModel {
  final String? cartId;
  final String? userId;
  final List<CartItemModel> cartItems;
  final double totalPrice;
  final int totalItem;

  CartModel({this.userId, this.cartId, required this.cartItems, required this.totalPrice, required this.totalItem});
  
  Map<String, dynamic> toMap(){
    return {
      'cartId': cartId,
      'userId': userId,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'totalItem': totalItem
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map){
    return CartModel(
      cartId: map['cartId'] ?? '',
      userId: map['userId'] ?? '',
      cartItems:(map['cartItems'] as List<dynamic>?)
        ?.map((item) => CartItemModel.fromMap(item as Map<String, dynamic>))
        .toList() ?? [], 
      totalPrice: map['totalPrice'] ?? 0, 
      totalItem: map['totalItem'] ?? 0
    );
  }
}
