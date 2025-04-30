class CartItemModel {
  final String cartId;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  CartItemModel({required this.price, required this.productId, required this.cartId, required this.productName, required this.productImage, required this.quantity});

  Map<String, dynamic> toMap(){
    return {
      'cartId': cartId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map){
    return CartItemModel(
      productId: map['productId'] ?? '', 
      cartId: map['cartId'] ?? '', 
      productName: map['productName'] ?? '', 
      productImage: map['productImage'] ?? '', 
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 1,
    );
  }
}