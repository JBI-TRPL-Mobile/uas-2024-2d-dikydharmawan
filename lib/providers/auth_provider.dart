import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void register(String name, String email, String password) {
    _user = User(name: name, email: email, password: password);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}