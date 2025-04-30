import 'package:aptech_project/models/cart_item_model.dart';

import './address_model.dart';

class OrderModel{
  final String orderId;
  final AddressModel address;
  final List<CartItemModel> items;
  final MyOrderStatus status;
  final DateTime startTime;
  final DateTime endTime;

  OrderModel({required this.orderId, required this.address, required this.items, required this.status, required this.startTime, required this.endTime});

  Map<String, dynamic> toMap(){
    return {
      'orderId': orderId,
      'address': address,
      'items': items.map((item) => item.toMap()).toList(),
      'status': status.value,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String()
    };
  }
  

  factory OrderModel.fromMap(Map<String, dynamic> map){
    return OrderModel(
      orderId: map['orderId'], 
      address: map['address'], 
      items: (map['items'] as List<dynamic> ? )?.map((item) => CartItemModel.fromMap(item as Map<String, dynamic>)).toList() ?? [], 
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