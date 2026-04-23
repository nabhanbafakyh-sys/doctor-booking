import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profilevm extends ChangeNotifier {
  String name = "";
  String phone = "";
  String email = "";

  bool isLoading = true;

  final user = FirebaseAuth.instance.currentUser;

  Profilevm() {
    loadUser(); // ✅ auto load when provider is created
  }

  Future<void> loadUser() async {
    if (user == null) return;

    isLoading = true;
    notifyListeners();

    final doc = await FirebaseFirestore.instance
        .collection('users') // ✅ make sure lowercase
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      name = doc['name'] ?? "";
      phone = doc['phone'] ?? "";
      email = doc['email'] ?? "";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) async {
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'name': name,
      'phone': phone,
      'email': email,
    }, SetOptions(merge: true));

    this.name = name;
    this.phone = phone;
    this.email = email;

    notifyListeners();
  }
}
