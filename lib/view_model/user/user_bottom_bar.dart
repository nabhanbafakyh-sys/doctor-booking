import 'package:flutter/material.dart';

class userbotomVM extends ChangeNotifier {
  int selectedpage = 0;

  void changepage(int index) {
    selectedpage = index;
    notifyListeners();
  }
}
