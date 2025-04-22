import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';



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
}