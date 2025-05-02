class UserModel {
  final String? userId;
  final String name;
  final String email;
  final String? profilePicture;
  final bool isAdmin;

  UserModel({
    this.userId,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.isAdmin,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      isAdmin: map['admin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'admin': isAdmin,
    };
  }
}
