import 'package:aptech_project/models/account_model.dart';
import 'package:aptech_project/models/address_model.dart';
import 'package:aptech_project/models/cart_item_model.dart';
import 'package:aptech_project/models/cart_model.dart';
import 'package:aptech_project/models/transaction_model.dart';
import 'package:aptech_project/services/auth_services.dart';
import 'package:aptech_project/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aptech_project/models/order_model.dart';


const uuid = Uuid();

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Handles all kinds of transactions (funding, checkout, etc.)
  /// Returns true if the transaction is successful.
  Future<bool> handleTransactions(TransactionModel transaction) async {
    try {
      User? user = _auth.currentUser;
      AccountModel? account = await AuthService().getAccountByUserId(user!.uid);
      
      print('user data from transaction method: $user \n account details: $account');
      final accountRef =  _firestore.collection('Accounts').doc(account!.accountId);
      final String transactionId =  uuid.v4();
      final transactionRef = _firestore.collection('Transactions').doc(transactionId);

      // Step 1: Get user's current wallet/account
      // DocumentSnapshot accountSnap = await accountRef.get();
      // if (!accountSnap.exists) throw Exception('User account not found');
      // final data = accountSnap.data() as Map<String, dynamic>;
      // AccountModel account = AccountModel.fromMap(data);

      double newBalance;

      // Step 2: Handle transaction based on its purpose
      switch (transaction.purpose.toLowerCase()) {
        case 'wallet_funding':
          newBalance = account!.accountBalance + transaction.amount;
          break;

        case 'checkout':
        case 'purchase':
          if (account!.accountBalance < transaction.amount) {
            throw Exception('Insufficient balance');
          }
          newBalance = account.accountBalance - transaction.amount;
          break;

        default:
          throw Exception('Unsupported transaction purpose: ${transaction.purpose}');
      }

      // Step 3: Update account balance
      await accountRef.update({'accountBalance': newBalance});

      // Step 4: Save the transaction as successful
      
      

      await transactionRef.set({
        'transactionId': transactionId,
        'userId': user.uid,
        'amount': transaction.amount,
        'purpose': transaction.purpose,
        'status': MyTransactionStatus.successful.name,
        'timestamp': DateTime.now(),
        'paymentMethod': transaction.paymentMethod,
        'reference': transaction.reference,
        'currency': transaction.currency,
        'description': transaction.description,
        'isRefunded': false,
        'metadata': transaction.metadata,
      });

      return true;
    } catch (e) {
      // You can also log the failed transaction here
      print('Transaction failed: $e');
      return false;
    }
  }

  /// Optionally, you can provide a helper to create a dummy transaction ID
  String generateTransactionId() {
    return const Uuid().v4();
  }

  Future<String> placeOrder(TransactionModel transaction, CartModel cart) async{
    try{
      bool isTransactionPassed = await handleTransactions(transaction);
      User? user = _auth.currentUser;
      print('user data: $user ${user!.uid} \n ${user.displayName} \n ${user.email}');
      if (!isTransactionPassed || user == null) {
        return 'Transaction failed';
      }
        String orderId = uuid.v4();
        AddressModel? address = await getRecentUserAddress();
        if (address == null) {
        return 'No delivery address found';
      }

       DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(const Duration(minutes: 3));

     OrderModel order = OrderModel(
      orderId: orderId,
      address: address,
      cart: cart,
      status: MyOrderStatus.pending,
      startTime: startTime,
      endTime: endTime,
    );

    // {
    //       'orderId': orderId,
    //       'address': address.toMap(),
    //       'items': items.map((item) => item.toMap()).toList(),
    //       'status': MyOrderStatus.pending.value,
    //       'startTime': DateTime.now(),
    //       'endTime': DateTime.now().add(const Duration(minutes: 3))
    //     }

        await _firestore.collection('Orders').doc(orderId).set(order.toMap());
        for (var i = 0; i < order.cart.cartItems.length; i++) {
                  await ProductService().removeCartItem(order.cart.cartItems[i].productId);
        }
        return 'Order placed successfully';

    }catch(e){
      print('error while placing orders: $e');
      return 'Order failed';
    }
  }

   Future<OrderModel?> getSingleOrder(String orderId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Orders').doc(orderId).get();
      if (doc.exists) {
        return OrderModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

 Future<List<OrderModel>> getUserOrders() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return [];
      final snapshot = await _firestore.collection('Orders').where('cart.userId', isEqualTo: user.uid).get();
      return snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error fetching user orders: $e');
      return [];
    }
  }

Future<bool> createAddress({
  required String country,
  required String city,
  required String postalCode,
}) async{
   try{
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('user is not logged in');
      }
      String addressId = uuid.v4();
      await _firestore.collection('Addresses').doc(addressId).set({
      'addressId': addressId,
      'userId': user.uid,
      'country': country,
      'city': city,
      'postalCode': postalCode
      });
      return true;
   }catch(e){
    print('error while creating address: $e');
    return false;
   }
}

Future<AddressModel?> getRecentUserAddress() async{
  try{
    User? user = _auth.currentUser;

    final snapshot = await _firestore
          .collection('Addresses')
          .where('userId', isEqualTo: user!.uid)
          .limit(1)
          .get();

if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return AddressModel.fromMap(data);
      } else {
        print('No address found for user ID: ${user.uid}');
        return null;
      }
    
  }catch(e){
    print('error in getting users recent address: $e');
    return null;
  }
}

Future<bool> updateAddress(AddressModel address) async {
    try {
      await _firestore.collection('Addresses').doc(address.addressId).update(address.toMap());
      return true;
    } catch (e) {
      print('Error updating address: $e');
      return false;
    }
  }
}
