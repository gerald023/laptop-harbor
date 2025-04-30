import 'package:aptech_project/models/cart_item_model.dart';
import 'package:aptech_project/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  Future<void> addProductToCart(String productId, int quantity)async{
    try{
      String cartId = uuid.v4();
      final ProductModels? product = await getProductById(productId);
      await _firestore.collection('CartItems').doc(cartId).set({
        'cartId': cartId,
        'productId': product!.productId,
        'productName': product.productName,
        'productImage': product.images[0],
        'price': product.discountedPrice < 1 ? product.price : product.discountedPrice * quantity,
        'quantity': quantity
      }, SetOptions(merge: true));
      final DocumentSnapshot  doc = await _firestore.collection('CartItems').doc(cartId).get();
      if (doc.exists && doc.data() != null) {  
            // final CartItemModel cartItem = CartItemModel.fromMap(cartItemSnapshot as Map<String, dynamic>);
            final data = doc.data() as Map<String, dynamic>;
            CartItemModel cartItem = CartItemModel.fromMap(data);
              addCartItem(cartItem);
              
          print(cartItem.toMap());

      }
      print('product added to cart!');
    }catch(e){
      print('error while adding product to cart: $e');
    }
  }

  Future<CartModel?> addCartItem(CartItemModel newItem)async{
    try{
        User? user = _auth.currentUser;
      if (user == null) {
        return null;
      }
      DocumentReference cartRef = _firestore.collection('Carts').doc(user.uid);

      return _firestore.runTransaction<CartModel>((transaction)async{
        DocumentSnapshot cartSnapshot = await transaction.get(cartRef);

      CartModel currentCart;
      if (!cartSnapshot.exists) {
        String cartId = uuid.v4();
        // If the cart doesn't exist, create a new one
        currentCart = CartModel(
          cartId: cartId,
          userId: user.uid,
          cartItems: [newItem],
          totalPrice: newItem.price * newItem.quantity,
          totalItem: newItem.quantity,
        );
        transaction.set(cartRef, currentCart.toMap());
        return currentCart; // Return the new cart
      } else {
        // If the cart exists, update it
        Map<String, dynamic> cartData = cartSnapshot.data() as Map<String, dynamic>;
        currentCart = CartModel.fromMap(cartData);

        // Check if the item already exists in the cart
        final existingIndex =
            currentCart.cartItems.indexWhere((item) => item.productId == newItem.productId);

        List<CartItemModel> updatedCartItems;
        if (existingIndex != -1) {
          // Update quantity if item exists
          updatedCartItems = List<CartItemModel>.from(currentCart.cartItems);
          updatedCartItems[existingIndex] = CartItemModel(
            cartId: updatedCartItems[existingIndex].cartId,
            productId: updatedCartItems[existingIndex].productId,
            productName: updatedCartItems[existingIndex].productName,
            productImage: updatedCartItems[existingIndex].productImage,
            price: updatedCartItems[existingIndex].price,
            quantity: updatedCartItems[existingIndex].quantity + newItem.quantity,
          );
        } else {
          // Add the new item
          updatedCartItems = [...currentCart.cartItems, newItem];
        }

        // Recalculate total price and item count
        double newTotalPrice = 0;
        int newTotalItem = 0;
        for (final item in updatedCartItems) {
          newTotalPrice += item.price * item.quantity;
          newTotalItem += item.quantity;
        }

        // Create the updated cart model
        CartModel updatedCart = CartModel(
          cartId: currentCart.cartId, // Keep the same cart ID if it exists
          userId: user.uid,
          cartItems: updatedCartItems,
          totalPrice: newTotalPrice,
          totalItem: newTotalItem,
        );

        // Update the cart document in Firestore
        transaction.update(cartRef, updatedCart.toMap());
        return updatedCart; // Return the updated cart
      }
      });
    }catch(e){
      print('error while adding item to cart: $e');
      return null;
    }
  }

    // Method to remove a CartItemModel from the cart in Firebase
  Future<CartModel?> removeCartItem(String productId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    final cartRef = _firestore.collection('Carts').doc(user.uid);

    try {
      return await _firestore.runTransaction<CartModel?>((transaction) async {
        final cartSnapshot = await transaction.get(cartRef);

        if (!cartSnapshot.exists) {
          throw Exception('Cart does not exist for user: ${user.uid}');
        }

        final cartData = cartSnapshot.data() as Map<String, dynamic>;
        final currentCart = CartModel.fromMap(cartData);

        // Filter out the item to remove
        final updatedCartItems =
            currentCart.cartItems.where((item) => item.productId != productId).toList();

        // Recalculate total price and item count
        double newTotalPrice = 0;
        int newTotalItem = 0;
        for (final item in updatedCartItems) {
          newTotalPrice += item.price * item.quantity;
          newTotalItem += item.quantity;
        }

        final updatedCart = CartModel(
          cartId: currentCart.cartId,
          userId: user.uid,
          cartItems: updatedCartItems,
          totalPrice: newTotalPrice,
          totalItem: newTotalItem,
        );

        // Update Firestore
        transaction.update(cartRef, updatedCart.toMap());

        return updatedCart;
      });
    } catch (e) {
      print('Error in removeCartItem transaction: $e');
      throw e;
    }
  }
  Future <CartModel?> getCartItems()async{
      try{
        User? user = _auth.currentUser;
        DocumentSnapshot snapshot = await _firestore.collection('Carts').doc(user!.uid).get();
        // return snapshot.docs.map((doc){
        //   final data = doc.data() as Map<String, dynamic>;
        //   data['cartId'] = doc.id;
        //   return CartModel.fromMap(data);
        // }).toList();
        if (!snapshot.exists) {
        return CartModel(cartItems: [], totalPrice: 0, totalItem: 0, userId: user.uid);
    }
        if (snapshot.exists) {
          final data = snapshot.data();
        if (data != null) {
          return CartModel.fromMap(data as Map<String, dynamic>);
        }
        }
        return null;
      }catch(e){
        print('error while getting cart items: $e');
        return null;
      }
  }
  Future<void> increaseCartQauntity(String cartId, int increament) async{
    try{
      final ref = _firestore.collection('Cart').doc(cartId);
      _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(ref);
        int quantity = snapshot['quantity'];
        if (quantity + increament >= 1) {
        transaction.update(ref, {'quantity': quantity + increament});
      }
      });
      print(ref);
    }catch(e){
      print('error while increasing cart quantity: $e');
    }
  }

    // Method to update the quantity of a CartItemModel in the cart
  Future<CartModel?> updateCartItemQuantity(String productId, int newQuantity) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    final cartRef = _firestore.collection('carts').doc(user.uid);

    try { // Add try-catch block here
      return await _firestore.runTransaction<CartModel?>((transaction) async {
        final cartSnapshot = await transaction.get(cartRef);

        if (!cartSnapshot.exists) {
          throw Exception('Cart does not exist for user: ${user.uid}');
        }

        final cartData = cartSnapshot.data() as Map<String, dynamic>;
        final currentCart = CartModel.fromMap(cartData);

        // Update the quantity of the item
        List<CartItemModel> updatedCartItems = currentCart.cartItems.map((item) {
          if (item.productId == productId) {
            // Important:  Only update if newQuantity is valid
            if (newQuantity > 0) {
              return CartItemModel(
                cartId: item.cartId,
                productId: item.productId,
                productName: item.productName,
                productImage: item.productImage,
                price: item.price, // Keep original price
                quantity: newQuantity,
              );
            } else {
              // Remove the item if the newQuantity is 0
              return null; // Return null to indicate removal
            }
          }
          return item;
        }).where((item) => item != null).cast<CartItemModel>().toList(); // Remove null items

        // Recalculate total price and item count
        double newTotalPrice = 0;
        int newTotalItem = 0;
        for (final item in updatedCartItems) {
          newTotalPrice += item.price * item.quantity;
          newTotalItem += item.quantity;
        }

        final updatedCart = CartModel(
          cartId: currentCart.cartId,
          userId: user.uid,
          cartItems: updatedCartItems,
          totalPrice: newTotalPrice,
          totalItem: newTotalItem,
        );

        // Update Firestore
        transaction.update(cartRef, updatedCart.toMap());
        return updatedCart;
      });
    } catch (e) {
      // Handle the error that occurred within the transaction.
      print('Error in updateCartItemQuantity transaction: $e');
      throw e; // Re-throw the error so the caller can handle it.
    }
  }
  //   Future<void> checkout(BuildContext context) async {
  //   final cartSnapshot = await FirebaseFirestore.instance.collection('cart').get();
  //   final cartItems = cartSnapshot.docs.map((doc) => doc.data()).toList();

  //   // Simulate real-time transaction
  //   showDialog(context: context, barrierDismissible: false, builder: (_) => Center(child: CircularProgressIndicator()));
  //   await Future.delayed(Duration(seconds: 2)); // Simulate payment

  //   final order = {
  //     'items': cartItems,
  //     'status': 'on the way',
  //     'timestamp': FieldValue.serverTimestamp(),
  //   };
  //   await FirebaseFirestore.instance.collection('orders').add(order);
  //   for (final doc in cartSnapshot.docs) {
  //     await doc.reference.delete();
  //   }
  //   Navigator.pop(context); // close dialog
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully')));
  // }

  static final _cartRef = FirebaseFirestore.instance.collection('Cart');
  static final _ordersRef = FirebaseFirestore.instance.collection('orders');
    
  static Stream<QuerySnapshot> getCartStream() {
    return _cartRef.snapshots();
  }

  static Future<void> checkout(BuildContext context) async {
    final cartSnapshot = await _cartRef.get();
    final cartItems = cartSnapshot.docs.map((doc) => doc.data()).toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(Duration(seconds: 2)); // Simulated payment delay

    final order = {
      'items': cartItems,
      'status': 'on the way',
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _ordersRef.add(order);

    for (final doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    Navigator.pop(context); // close dialog
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully')));
  }

}