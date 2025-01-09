import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  List<User> _registeredUsers = [];
  static const String _fileName = 'users.json';

  bool get isLoggedIn => _user != null;
  User? get user => _user;

  AuthProvider() {
    _loadUsers();
  }

  // Get the local file path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get reference to the local file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  // Load users from JSON file
  Future<void> _loadUsers() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        _registeredUsers = jsonList.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  // Save users to JSON file
  Future<void> _saveUsers() async {
    try {
      final file = await _localFile;
      final jsonList = _registeredUsers.map((user) => user.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving users: $e');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      if (_registeredUsers.any((user) => user.email == email)) {
        throw Exception('Email already registered');
      }

      final newUser = User(name: name, email: email, password: password);
      _registeredUsers.add(newUser);
      await _saveUsers();
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = _registeredUsers.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );
      
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
        final existingUser = _registeredUsers.firstWhere(
          (user) => user.email == googleUser.email,
          orElse: () {
            final newUser = User(
              name: googleUser.displayName ?? 'Google User',
              email: googleUser.email,
              password: '',
            );
            _registeredUsers.add(newUser);
            _saveUsers(); // Save after adding new user
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
        
        final existingUser = _registeredUsers.firstWhere(
          (user) => user.email == email,
          orElse: () {
            final newUser = User(
              name: userData['name'] ?? 'Facebook User',
              email: email,
              password: '',
            );
            _registeredUsers.add(newUser);
            _saveUsers(); // Save after adding new user
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

  void printRegisteredUsers() {
    print('Registered Users (from JSON):');
    print(json.encode(_registeredUsers.map((user) => user.toJson()).toList()));
  }
}
