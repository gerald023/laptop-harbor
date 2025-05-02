class TransactionModel {
   final String? transactionId;
  final String? userId;
  final double amount;
  final String purpose;
  final MyTransactionStatus? status;
  final DateTime? timestamp;
  final String paymentMethod;
  final String reference;
  final String currency;
  final String description;
  final bool? isRefunded;
  final Map<String, dynamic>? metadata;

   TransactionModel({
    this.transactionId,
    this.userId,
    this.status,
    this.timestamp,
    this.isRefunded,
    required this.amount,
    required this.purpose,
    required this.paymentMethod,
    required this.reference,
    required this.currency,
    required this.description,
    this.metadata,
  });

   factory TransactionModel.fromMap(Map<String, dynamic> map, {required MyTransactionStatus status}) {
    return TransactionModel(
      transactionId: map['transactionId'],
      userId: map['userId'],
      amount: (map['amount'] as num).toDouble(),
      purpose: map['purpose'],
      status: MyTransactionStatusExtension.fromString(map['status']),
      timestamp: DateTime.parse(map['timestamp']),
      paymentMethod: map['paymentMethod'],
      reference: map['reference'],
      currency: map['currency'],
      description: map['description'],
      isRefunded: map['isRefunded'] ?? false,
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'userId': userId,
      'amount': amount,
      'purpose': purpose,
      'status': status!.value,
      'timestamp': timestamp!.toIso8601String(),
      'paymentMethod': paymentMethod,
      'reference': reference,
      'currency': currency,
      'description': description,
      'isRefunded': isRefunded,
      'metadata': metadata,
    };
  }
}






enum MyTransactionStatus { pending, successful, failed }

extension MyTransactionStatusExtension on MyTransactionStatus {
  String get value {
    switch (this) {
      case MyTransactionStatus.pending:
        return 'pending';
      case MyTransactionStatus.successful:
        return 'successful';
      case MyTransactionStatus.failed:
        return 'failed';
    }
  }

  static MyTransactionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return MyTransactionStatus.pending;
      case 'successful':
        return MyTransactionStatus.successful;
      case 'failed':
        return MyTransactionStatus.failed;
      default:
        throw Exception('Invalid transaction status: $status');
    }
  }
}