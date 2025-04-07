import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aptech_project/services/auth_services.dart';

final firebaseServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
