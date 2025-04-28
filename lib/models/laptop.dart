import 'review.dart';

class Laptop {
  final String productId;
  final String productName;
  final String productInfo;
  final bool isProductAvailable;
  final List<String> images;
  final String displayImage;
  final String category;
  final double price;
  final double discountedPrice;
  final int discountPercent;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Review> reviews;

  Laptop({
    required this.productId,
    required this.productName,
    required this.productInfo,
    required this.isProductAvailable,
    required this.images,
    required this.displayImage,
    required this.category,
    required this.price,
    required this.discountedPrice,
    required this.discountPercent,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.reviews,
  });

  // Convenience getters to match the original Laptop class fields
  String get name => productName;
  String get brand => category; // Using category as brand temporarily until we have proper data
  String get processor => productInfo.contains('Processor') ? productInfo.split('Processor:')[1].split(',')[0].trim() : 'N/A';
  int get ram => 16; // Default value, would be populated from ProductDetails in a full implementation
  int get storage => 512; // Default value, would be populated from ProductDetails in a full implementation
  double get screenSize => 15.6; // Default value, would be populated from ProductDetails in a full implementation
  String get imageUrl => displayImage;
}