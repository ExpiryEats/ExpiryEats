import 'package:expiry_eats/managers/user_model.dart';
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners(); 
  }
}