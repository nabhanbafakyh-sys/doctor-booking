import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class loginAuth extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isloading = false;

  Future<String?> login(String email, String password) async {
    try {
      isloading = true;
      notifyListeners();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      isloading = false;
      notifyListeners();

      return null; // success
    } on FirebaseAuthException catch (e) {
      isloading = false;
      notifyListeners();
      return e.message;
    }
  }
}
