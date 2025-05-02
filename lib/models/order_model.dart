import 'package:aptech_project/models/cart_model.dart';

import './address_model.dart';

class OrderModel{
  final String orderId;
  final AddressModel address;
  final CartModel cart;
  final MyOrderStatus status;
  final DateTime startTime;
  final DateTime endTime;

  OrderModel({required this.orderId, required this.address, required this.cart, required this.status, required this.startTime, required this.endTime});

  Map<String, dynamic> toMap(){
    return {
      'orderId': orderId,
      'address': address.toMap(),
      'cart': cart.toMap(),
      'status': status.value,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
  

  factory OrderModel.fromMap(Map<String, dynamic> map){
    return OrderModel(
      orderId: map['orderId'],
      address: AddressModel.fromMap(map['address']),
      cart: CartModel.fromMap(map['cart']),
      status: MyOrderStatusExtension.fromString(map['status']),
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime'])
    );
  }
}



enum MyOrderStatus { pending, delivered, canceled }

extension MyOrderStatusExtension on MyOrderStatus {
  String get value {
    switch (this) {
      case MyOrderStatus.pending:
        return 'pending';
      case MyOrderStatus.delivered:
        return 'delivered';
      case MyOrderStatus.canceled:
        return 'canceled';
    }
  }

  static MyOrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return MyOrderStatus.pending;
      case 'delivered':
        return MyOrderStatus.delivered;
      case 'canceled':
        return MyOrderStatus.canceled;
      default:
        throw Exception('Invalid transaction status: $status');
    }
  }
}