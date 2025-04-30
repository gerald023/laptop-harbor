class AddressModel {
  final String? addressId;
  final String? userId;
  final String country;
  final String city;
  final String postalCode;

  AddressModel({ this.addressId, this.userId, required this.country, required this.city, required this.postalCode});

  Map<String, dynamic> toMap(){
    return {
      'addressId': addressId,
      'userId': userId,
      'country': country,
      'city': city,
      'postalCode': postalCode
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map){
    return AddressModel(
      addressId: map['addressId'] ?? '',
      userId: map['userId'] ?? '',
      country: map['country'] ?? '', 
      city: map['city'] ?? '', 
      postalCode: map['postalCode'] ?? ''
    );
  }
}