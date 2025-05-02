import 'dart:convert';
import 'package:aptech_project/models/account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aptech_project/models/userModel.dart';



const uuid = Uuid();

class AuthService{
  AuthService._privateConstructor();
  
  static final _instance = AuthService._privateConstructor();

  factory AuthService(){
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

     String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password
  }) async{
    print('the beginning');
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        String hashPassword = _hashPassword(password);

        Map<String, dynamic> data = {
          'userId': user.uid,
          'name': name,
          'email': email,
          'password': hashPassword,
          'admin': false,
          'signInMethod': 'email-pass',
          'profilePicture':
              'https://res.cloudinary.com/dn7xnr4ll/image/upload/v1722866767/notionistsNeutral-1722866616198_iu61hw.png',
        };

        await _firestore.collection('Users').doc(user.uid).set(data);
        print('user created!!');
          // Update display name
        await user.updateDisplayName(name);
        await user.updatePhotoURL(
            'https://res.cloudinary.com/dn7xnr4ll/image/upload/v1722866767/notionistsNeutral-1722866616198_iu61hw.png');
        await user.reload();

        // Send email verification
        await user.sendEmailVerification();
        print('userId: ${user.uid} \n userName: $name');
        await createUserAccount(
          accountName: name,
          userId: user.uid
        );
        print('email sent!!');
        return null;
      }
    }on FirebaseAuthException catch(e){
      print(e);
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'network-request-failed':
          return 'Network error occurred. Please check your connection.';
        default:
        print(e);
          return 'An unknown error occurred. Please try again.';
      }
    }catch(e){
      print(e);
      return 'An unexpected error occurred. Please try again.';
    }
    return 'Sign up failed. Please try again';
  }



  Future<Map<String, dynamic>?> signIn({
    required String email,
    required String password
  }) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('Users').doc(user.uid).get();
        // await FirebaseAuth.instance.currentUser?.delete();
        if (userDoc.exists) {
          bool isAdmin = userDoc.get('admin') ?? false;
          return {
            'isAdmin': isAdmin,
            'message': null
          };
          
        }else {
          return {
            'isAdmin': false,
            'message': 'User data not found.',
          };
        }
      }else {
        return {
          'isAdmin': false,
          'message': 'Login failed. Please try again.',
        };
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          return {'isAdmin': false, 'message': 'Invalid email or password.'};
        case 'user-disabled':
          return {'isAdmin': false, 'message': 'This user has been disabled.'};
        case 'user-not-found':
          return {
            'isAdmin': false,
            'message': 'No user found with this email.'
          };
        case 'wrong-password':
          return {
            'isAdmin': false,
            'message': 'The password is incorrect. Please try again.'
          };
        default:
          return {
            'isAdmin': false,
            'message': 'An error occurred. Please try again.'
          };
      }
    }catch (e) {
       return {
        'isAdmin': false,
        'message': 'An unexpected error occurred. Please try again.'
      };
    }
  }

  // sign out method
  Future<void> signOut() async {
    try{
      await _auth.signOut();
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('hasOnboarded', true);
    // await prefs.setBool('isLoggedIn', false);
    // if (prefs.getBool('isLoggedIn')!) {
    //     print('user is logged in did not change');
    // }else{
    //   print('user is logged in did change');
    // }
    print('user is logged out');
    } on FirebaseAuthException catch(e){
      print(e.code);
    }catch(e){
      print(e);
    }
  }

  Future<String?> updateUserProfile({
  String? name,
  String? email,
  String? password,
  String? profilePicture,
}) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) return 'No authenticated user';

    final userRef = _firestore.collection('Users').doc(user.uid);
    final docSnap = await userRef.get();

    if (!docSnap.exists) return 'User profile not found';

    final existingData = docSnap.data()!;

    // Update Firebase Auth profile if needed
    if (name != null && name != user.displayName) {
      await user.updateDisplayName(name);
    }

    if (profilePicture != null && profilePicture != user.photoURL) {
      await user.updatePhotoURL(profilePicture);
    }

    if (email != null && email != user.email) {
      await user.updateEmail(email);
    }

    if (password != null && password.isNotEmpty) {
      await user.updatePassword(password);
    }

    // Re-hash password only if it is being updated
    String? hashedPassword =
        password != null ? _hashPassword(password) : existingData['password'];

    // Merge updated fields into Firestore document
    await userRef.update({
      'name': name ?? existingData['name'],
      'email': email ?? existingData['email'],
      'password': hashedPassword,
      'profilePicture': profilePicture ?? existingData['profilePicture'],
    });

    await user.reload();
    return 'profile updated';
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException: ${e.code}');
    switch (e.code) {
      case 'requires-recent-login':
        return 'Please re-authenticate to update this information.';
      case 'email-already-in-use':
        return 'This email is already in use by another account.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'Auth error: ${e.message}';
    }
  } catch (e) {
    print('Error in updateUserProfile: $e');
    return 'An error occurred while updating profile.';
  }
}

Future<bool> isUserAdmin() async{
  try{
    User? user = _auth.currentUser;
    DocumentSnapshot doc = await _firestore.collection('Users').doc(user!.uid).get();
    final data = doc.data() as Map<String, dynamic>;
    final userData = UserModel.fromMap(data);
    
    if (userData.isAdmin) {
      return true;
    }else{
      return false;
    }
  }catch(e){
    print('is user admin: $e');
    return false;
  }
}
Future<String?> updateUserPhoto(String newPhotoUrl) async {
  try {
    User? user = _auth.currentUser;
    if (user == null) return 'No authenticated user';

    await user.updatePhotoURL(newPhotoUrl);
    await _firestore.collection('Users').doc(user.uid).update({
      'profilePicture': newPhotoUrl,
    });

    await user.reload();
    return null;
  } catch (e) {
    print('Error updating photo: $e');
    return 'Failed to update profile picture.';
  }
}


Future<UserModel?> getCurrentUserModel() async {
  try {
    User? user = _auth.currentUser;
    if (user == null) return null;

    final docSnap = await _firestore.collection('Users').doc(user.uid).get();

    if (docSnap.exists) {
      final data = docSnap.data()!;
      return UserModel.fromMap(data);
    }
  } catch (e) {
    print('Error getting user model: $e');
  }
  return null;
}


  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

    Future<void> createUserAccount({
      required String userId,
      required String accountName
    }) async {
      try{
          final String accountId = const Uuid().v4();
        print('from create account method: \n userName: $accountName \n userId: $userId');
    final account = AccountModel(
      currency: 'USD',
      accountId: accountId,
      userId: userId,
      accountName: accountName,
      accountBalance: 0.0,

    );
    print('accountName: ${account.accountName} \n account: $account');
    
  print('creating your account');
    await _firestore.collection('Accounts').doc(accountId).set({
      'accountId': accountId,
      'userId': userId,
      'accountName': accountName,
      'accountBalance': 0.0,
      'currency': 'USD',
      'createdAt': DateTime.now()
    });
    await _secureStorage.write(key: 'accountId', value: accountId);
    print('accountName: ${account.accountName} \n account: $account');
      }catch(e){
        print('error while creating account: $e');
      }
  }

  Future<AccountModel?> getAccountByUserId(String userId) async{
    try{
      final docRef = _firestore.collection('Accounts').where('userId', isEqualTo: userId).limit(1);
      final QuerySnapshot querySnapshot = await docRef.get();


      print('Query returned ${querySnapshot.docs.length}');
       if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final rawData = docSnapshot.data() as Map<String, dynamic>;

      if (rawData != null) {
        print('Product details data: $rawData');
        return AccountModel.fromMap(rawData);
      } else {
        print('Invalid or null data in document for userId: $userId');
        return null;
      }
    } 
    }catch(e, stacktrace){
      print('error while getting account details: $e');
      print('Stacktrace: $stacktrace');
      return null;
    }
    return null;
  }
}