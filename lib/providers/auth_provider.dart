import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> register(String name, String email, String password) async {
    // Implementasi logika registrasi
    print('Registering user: $name, $email');
    // Panggil API atau simpan data ke database
  }

  Future<void> signIn(String email, String password) async {
    // Implementasi logika sign in
    print('Signing in user: $email');
    // Panggil API atau verifikasi data
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
