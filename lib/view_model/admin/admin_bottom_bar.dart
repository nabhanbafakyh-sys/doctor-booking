import 'package:flutter/material.dart';

class AdminBottomBarvm extends ChangeNotifier {
  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
