import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool get isLoggedIn => _user != null;
  User? get user => _user;

  // Simpan data user yang sudah terdaftar
  final List<User> _registeredUsers = [];

  Future<void> register(String name, String email, String password) async {
    try {
      // Cek apakah email sudah terdaftar
      if (_registeredUsers.any((user) => user.email == email)) {
        throw Exception('Email already registered');
      }

      // Simulasi API call
      await Future.delayed(Duration(seconds: 1));

      // Buat user baru
      final newUser = User(name: name, email: email, password: password);

      // Simpan ke daftar user
      _registeredUsers.add(newUser);

      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      // Simulasi API call
      await Future.delayed(Duration(seconds: 1));

      // Cari user dengan email dan password yang sesuai
      final user = _registeredUsers.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );

      // Set user aktif
      _user = user;
      notifyListeners();
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        // Cek apakah email sudah terdaftar
        final existingUser = _registeredUsers.firstWhere(
          (user) => user.email == googleUser.email,
          orElse: () {
            // Jika belum terdaftar, buat user baru
            final newUser = User(
              name: googleUser.displayName ?? 'Google User',
              email: googleUser.email,
              password: '', // Password kosong untuk social login
            );
            _registeredUsers.add(newUser);
            return newUser;
          },
        );
        _user = existingUser;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final email = userData['email'] ?? 'no-email@facebook.com';

        // Cek apakah email sudah terdaftar
        final existingUser = _registeredUsers.firstWhere(
          (user) => user.email == email,
          orElse: () {
            // Jika belum terdaftar, buat user baru
            final newUser = User(
              name: userData['name'] ?? 'Facebook User',
              email: email,
              password: '', // Password kosong untuk social login
            );
            _registeredUsers.add(newUser);
            return newUser;
          },
        );
        _user = existingUser;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Facebook sign in failed: $e');
    }
  }

  void signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FacebookAuth.instance.logOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Method untuk debugging
  void printRegisteredUsers() {
    print('Registered Users:');
    for (var user in _registeredUsers) {
      print('Name: ${user.name}, Email: ${user.email}');
    }
  }
}
