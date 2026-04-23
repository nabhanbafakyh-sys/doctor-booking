import 'package:flutter/material.dart';

class RoleViewModel extends ChangeNotifier {
  String? selectedRole;

  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }
}
