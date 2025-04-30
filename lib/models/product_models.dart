// import 'package:aptech_project/types/product_types.dart';
// import 'package:image_picker/image_picker.dart';

class ProductModels{
  final String productId;
   final String productName;
    final String productInfo;
    final bool isProductAvailable;
    final List<String> images;
    final String category;
    final double price;
    final double newDiscountPrice;
    final int? discountPercent;
    // final ProductDetailsType productDetails;

  ProductModels({required this.productId, required this.newDiscountPrice, required this.productName, required this.productInfo, required this.isProductAvailable, required this.images, required this.category, required this.price, required this.discountPercent, 
  // required this.productDetails
  });

@override
String toString(){
  return 'ProductModels( productId: $productId, productName: $productName, productInfo: $productInfo, isProductAvailable: $isProductAvailable, images: $images, category: $category, price: $price, discountPercent: $discountPercent, discountedPrice: $newDiscountPrice)';
}
  Map<String, dynamic> topMap(){
    return {
      'productId': productId,
      'productName': productName,
      'productInfo': productInfo,
      'isProductAvailable': isProductAvailable,
      'images': images,
      'category': category,
      'price': price,
      'discountPercent': discountPercent,
      'discountedPrice': newDiscountPrice,
      // 'productDetails': productDetails,
    };
  }

factory ProductModels.fromMap(Map<String, dynamic> map){
  return ProductModels(
    productId: map['productId'] ?? '',
  newDiscountPrice: map['newDiscountPrice'] ?? 0, 
  productName: map['productName'] ?? '', 
  productInfo: map['productInfo'] ?? '', 
  isProductAvailable: map['isProductAvailable'] ?? true, 
  images: List<String>.from(map['images'] ?? []), 
  category: map['category'] ?? '', 
  price: map['price'] ?? 0, 
  discountPercent: map['discountPercent'] ?? 0, 
  // productDetails: map['productDetails'] ?? ''
  );
}
}