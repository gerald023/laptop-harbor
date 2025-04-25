class ReviewsModel {
  String? reviewId;
  String? productId;
  String? userId;
  double rating;
  String reviewMessage;

  ReviewsModel({required this.rating, required this.reviewMessage, this.productId,  this.reviewId,  this.userId,});

  @override
  String toString() {
    return 'ReviewsModal(reviewId: $reviewId, productId: $productId, userId: $userId, rating: $rating, reviewMessage: $reviewMessage)';
  }

  Map<String, dynamic>  toMap(){
    return {
      'reviewId': reviewId,
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'reviewMessage': reviewMessage
    };
  }

  factory ReviewsModel.fromMap(Map<String, dynamic> map){
    return ReviewsModel(
      reviewId: map['productId'] ?? '', 
      userId: map['rating'] ?? '',
      productId: map['productId'] ?? '', 
      reviewMessage: map['reviewMessage'] ?? '',
      rating: map['rating'] ?? 0
    );
  }
}