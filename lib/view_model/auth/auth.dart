import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/view/role/role.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<User?> get authState => _auth.authStateChanges();

  bool isLoading = false;
  String? error;

  /// 🔐 LOGIN
  Future<bool> signIn(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _ensureGlobalUser(cred.user);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🌍 GLOBAL USER
  Future<void> _ensureGlobalUser(User? user) async {
    if (user == null) return;

    final ref = _db.collection('users').doc(user.uid);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({'email': user.email, 'createdAt': Timestamp.now()});
    }
  }

  /// 🏥 CREATE CLINIC (ADMIN)
  Future<String?> createClinic(String clinicName) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) return null;

      final ref = await _db.collection('clinics').add({
        'name': clinicName,
        'adminId': user.uid,
        'createdAt': Timestamp.now(),
      });

      /// Add admin to clinic users
      await _db
          .collection('clinics')
          .doc(ref.id)
          .collection('users')
          .doc(user.uid)
          .set({
            'name': user.email?.split('@')[0] ?? '',
            'email': user.email,
            'role': 'admin',
            'clinicId': ref.id,
          });

      return ref.id;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 👤 ATTACH USER TO CLINIC
  Future<void> attachUserToClinic(String clinicId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final ref = _db
        .collection('clinics')
        .doc(clinicId)
        .collection('users')
        .doc(user.uid);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'name': user.email?.split('@')[0] ?? '',
        'email': user.email,
        'phone': '',
        'role': 'patient',
        'clinicId': clinicId,
        'createdAt': Timestamp.now(),
      });
    }
  }

  /// 🔍 GET ROLE
  Future<String?> getRole(String clinicId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db
        .collection('clinics')
        .doc(clinicId)
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      return doc.data()?['role'];
    }

    return null;
  }

  /// 🔎 CHECK IF ADMIN HAS CLINIC
  Future<bool> hasClinic() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final snap = await _db
        .collection('clinics')
        .where('adminId', isEqualTo: user.uid)
        .get();

    return snap.docs.isNotEmpty;
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }
}
