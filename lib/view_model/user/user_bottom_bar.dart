import 'package:flutter/material.dart';

class BottomBarviewmodel extends ChangeNotifier {
  int selectedpage = 0;

  void changepage(int index) {
    selectedpage = index;
    notifyListeners();
  }
}
