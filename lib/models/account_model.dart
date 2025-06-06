import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final String accountId;
  final String userId;
  final String accountName;
  final double accountBalance;
  final String? currency;
  final DateTime? createdAt;


  AccountModel( { this.currency,  this.createdAt, required this.accountId, required this.userId, required this.accountName, required this.accountBalance});

  Map<String, dynamic> toMap(){
    return {
      'accountId': accountId,
      'userId': userId,
      'accountName': accountName,
      'accountBalance': accountBalance,
       'currency': currency,
      'createdAt': Timestamp.fromDate(createdAt!),
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map){
    return AccountModel(
      accountId: map['accountId'] ?? '', 
      userId: map['userId'] ?? '', 
      accountName: map['accountName'] ?? '', 
      accountBalance: map['accountBalance'] ?? 0.0,
      currency: map['currency'] ?? 'USD',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}