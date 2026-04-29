import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileVM extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String name = "";
  String email = "";
  String phone = "";
  String role = "";

  bool isLoading = true;

  StreamSubscription? _authSub;

  ProfileVM() {
    _listenToAuth();
  }
  void clear() {
    name = "";
    email = "";
    phone = "";
    role = "";
    isLoading = true;
    notifyListeners();
  }

  void _listenToAuth() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        loadUser();
      } else {
        _clearData();
      }
    });
  }

  Future<void> loadUser() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _clearData();
        return;
      }

      final doc = await _db.collection('Users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        name = data['name'] ?? "";
        email = data['email'] ?? user.email ?? "";
        phone = data['phone'] ?? "";
        role = data['role'] ?? "";
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Load error: $e");
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔥 Update profile
  Future<bool> updateProfile({
    required String newName,
    required String newPhone,
    required String newEmail,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // Update email (may require re-login)
      if (user.email != newEmail) {
        await user.updateEmail(newEmail);
      }

      await _db.collection('Users').doc(user.uid).update({
        'name': newName,
        'phone': newPhone,
        'email': newEmail,
      });

      // Update local state instantly
      name = newName;
      phone = newPhone;
      email = newEmail;

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Update error: $e");
      return false;
    }
  }

  /// 🔥 Clear data when user logs out
  void _clearData() {
    name = "";
    email = "";
    phone = "";
    role = "";
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
