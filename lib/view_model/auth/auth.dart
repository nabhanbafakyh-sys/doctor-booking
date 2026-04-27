import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool isLoading = false;
  String? error;

  AuthViewModel() {
    listenToAuthChanges(); // 🔥 important
  }

  Stream<User?> get authState => _auth.authStateChanges();

  Future<bool> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _ensureUserDoc(cred.user);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void listenToAuthChanges() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _ensureUserDoc(user);
      }
    });
  }

  Future<void> _ensureUserDoc(User? user) async {
    if (user == null) return;

    final ref = _db.collection('users').doc(user.uid);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'name': user.email?.split('@')[0] ?? '',
        'email': user.email,
        'phone': '',
        'role': 'patient',
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<String?> getRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    return doc.data()?['role'];
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
