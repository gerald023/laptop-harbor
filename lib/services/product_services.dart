import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cloudinary_flutter/cloudinary_object.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:aptech_project/models/product_models.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:aptech_project/services/cloudinary_upload_service.dart';
import  'package:aptech_project/types/product_types.dart';
import 'package:aptech_project/models/reviews_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



const uuid = Uuid();

class ProductService{
  ProductService._privateConstructor();

  static final _instance = ProductService._privateConstructor();
  
  factory ProductService(){
    return _instance;
  }

  // firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final flutter_storage = FlutterSecureStorage();

  // cloudinary instances
  void cloudinaryService(){
    CloudinaryObject.fromCloudName(cloudName: 'dbjehxk0f');
    Cloudinary.fromCloudName(cloudName: 'dbjehxk0f');
  }

  Future<String?> createProduct({
    required String productName,
    required String productInfo,
    required bool isProductAvailable,
    required List<XFile> images,
    required String category,
    required double price,
    int? discountPercent
  }) async {
    try{
      print('adding product started');
      User? user = _auth.currentUser;
      if (user == null) {
        return 'User is not logged in';
      }
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();

      bool isAdmin = userDoc.get('admin') ?? false;
      if (!isAdmin) {
        return 'only admin can create product';
      }

      List<String> imagesUrls = [];
      String displayImgUrl = '';
      try{
        final cloudinary_upload = CloudinaryUploadService();
       
        for (XFile image in images) {
          String? uploadUrl = await cloudinary_upload.uploadImageToCloudinary(image);
          if (uploadUrl != null) {
            imagesUrls.add(uploadUrl);
            displayImgUrl = imagesUrls[0];
          }else{
            return 'image: $image \t $uploadUrl did not upload';
          }
        }
        print('display image: \t $displayImgUrl \n product images: \t $imagesUrls');
      }catch(e){
        print('failed to upload product images $e');
        return 'Images not uploaded';
      }
      String productId = uuid.v4();
      await flutter_storage.write(key: 'createdProductId', value: productId);
      double estDiscountPrice = price - price / 100 * discountPercent!;
      double newDiscountPrice = double.parse(estDiscountPrice.toStringAsFixed(2));

      await _firestore.collection('Products').doc(productId).set({
        'productId': productId,
        'productName': productName,
        'productInfo': productInfo,
        'isProductAvailable': isProductAvailable,
        'images': imagesUrls,
        'displayImage': displayImgUrl,
        'category': category,
        'price': price,
        'discountedPrice': newDiscountPrice,
        'discountPercent': discountPercent,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await flutter_storage.write(key: 'createdProductId', value: productId);
      return productId;
    } catch(e){
      print('error while creating product:  $e');
      return 'Error while creating product';
    }
  }

  Future<String?> AddProductDetails({
    required BasicInfo basicInfo,
    required Battery batteryInfo,
    required OperatingSystem OSInfo,
    required BuildAndDesign designInfo,
    required Memory memoryInfo,
    required Processor processorInfo,
    required Display displayInfo
  }) async {
      try{
        print('started product details upload');
        User? user = _auth.currentUser;
        if (user == null) {
          return 'User is not logged in';
        }
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();
        bool isAdmin = userDoc.get('admin') ?? false;
        if (!isAdmin) {
          return 'only admin can add product details';
        }

        String detailsId = uuid.v4();
        String? productId = await flutter_storage.read(key: 'createdProductId')?? '';
        await _firestore.collection('ProductDetails').doc(detailsId).set({
          'productDetailsID': detailsId,
          'productId': productId,
          'basicInfo': basicInfo.toMap(),
          'batteryInfo': batteryInfo.toMap(),
          'OSInfo': OSInfo.toMap(),
          'designInfo': designInfo.toMap(),
          'memoryInfo': memoryInfo.toMap(),
          'processorInfo': processorInfo.toMap(),
          'displayInfo': displayInfo.toMap(),
          'createdBy': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        await flutter_storage.delete(key: 'createdProductId');
        print(productId);
        return 'product details successfully added!!!';
      }catch(e){
          await flutter_storage.delete(key: 'createdProductId');
        print('error while uploading product details $e');
        return 'error while uploading product details';
      }
  }

  Future<List<ProductModels>> getAllProducts() async{
    try{
      QuerySnapshot productSnapshot = await _firestore.collection('Products').get();
      return productSnapshot.docs.map((doc){
        final data = doc.data() as Map<String, dynamic>;
        data['productId'] = doc.id;
        return ProductModels.fromMap(data);
      }).toList();
    }catch(e){
      print('Error while getting all products: $e');
      return [];
    }
  }

  Future<List<ProductModels>> getPopularProducts() async{
    try{
      final allProducts =  await getAllProducts();
      final popularProducts = allProducts.where((product){
        return product.discountPercent  != null && product.discountPercent! > 10;
      }).toList();
      
      return popularProducts;
    } catch (e) {
    print('Error while getting popular products: $e');
    return [];
  }
  }

  Future<ProductModels?> getProductById(String productId) async{
    try{
      DocumentSnapshot doc = await _firestore.collection('Products').doc(productId).get();
      if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['productId'] = doc.id;
      return ProductModels.fromMap(data);
      } else {
      print('No product found with ID: $productId');
      return null;
        }
    }catch(e){
      print('Error getting product by ID: $e');
      return null;
    }
  }

  Future<ProductDetailsModel?> getProductDetail(String productId) async{
    try{
      QuerySnapshot snapshot = await _firestore.collection('ProductDetails')
      .where('productId', isEqualTo: productId)
      .limit(1)
      .get();
    
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;

      // Replace with your own parsing logic depending on ProductDetailsType
      return ProductDetailsModel.fromMap(data); 
    } else {
      print('No product details found for productId: $productId');
      return null;
    }
    }catch(e){
      print('error while getting product details $e');
      return null;
    }
    
  }


  Future<bool> addProductReview(ReviewsModel data) async{
      try{
        User? user = _auth.currentUser;
      
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user!.uid).get();

      String userId = userDoc.get('userId') ?? '';
      print(userId);
      String reviewId = uuid.v4();
      DocumentSnapshot reviewDoc = await _firestore.collection('Reviews').doc('userId').get();
      if (reviewDoc.exists) {
        
      }else{
        await _firestore.collection('Reviews').doc(reviewId).set(
          data.toMap()
        );
        return true;
      }
      return true;
      }catch(e){
        print('error while adding review: $e');
        return false;
      }
  }

  Future<List<ReviewsModel>> getAllProductReviews(String productId) async {
    try{
      QuerySnapshot querySnapshot = await _firestore.collection('Reviews')
        .where('productId', isEqualTo: productId)
        .get();

      return querySnapshot.docs.map((doc){
        final data = doc.data() as Map<String, dynamic>;
        data['reviewId'] = doc.id;
        return ReviewsModel.fromMap(data);
      }).toList();
    }catch(e){
      print('error in getting product reviews: $e');
      return [];
    }
  }

  Future<ReviewsModel?> getProductReviewById(String reviewId) async{
    try{
      DocumentSnapshot doc = await _firestore.collection('Reviews').doc(reviewId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return ReviewsModel.fromMap(data);
        
      }
      return null;
    }catch(e){
      print('error while getting the product\'s review: $e');
      return null;
    }

  }
}