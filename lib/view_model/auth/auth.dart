import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view_model/user/profile.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AuthViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  bool isLoading = false;
  String? error;

  Stream<User?> get authState => _auth.authStateChanges();

  Future<bool> signIn(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _ensureGlobalUser(cred.user); // ✅ only global

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ✅ GLOBAL USER (basic info only)
  Future<void> _ensureGlobalUser(User? user) async {
    if (user == null) return;

    final ref = _db.collection('users').doc(user.uid);

    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({'email': user.email, 'createdAt': Timestamp.now()});
    }
  }

  // ✅ ADD USER TO CLINIC (IMPORTANT 🔥)
  Future<void> attachUserToClinic(BuildContext context) async {
    final user = _auth.currentUser;
    final clinicId = context.read<ClinicProvider>().clinicId;

    if (user == null || clinicId == null) return;

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
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();

    context.read<ProfileVM>().clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
      (route) => false,
    );
  }

  Future<String?> getRole(BuildContext context) async {
    final user = _auth.currentUser;
    final clinicId = context.read<ClinicProvider>().clinicId;

    if (user == null || clinicId == null) return null;

    try {
      final doc = await _db
          .collection('clinics')
          .doc(clinicId)
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data()?['role'];
      }
    } catch (e) {
      debugPrint("Get role error: $e");
    }

    return null;
  }
}
