import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view_model/admin/admin_bottom_bar.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';
import 'package:room_rental/view_model/admin/admin_profile.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';
import 'package:room_rental/view_model/user/homeviewmodel.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<User?> get authState => _auth.authStateChanges();

  bool isLoading = false;
  String? error;

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

  Future<void> _ensureGlobalUser(User? user) async {
    if (user == null) return;

    final ref = _db.collection('users').doc(user.uid);
    final doc = await ref.get();

    if (!doc.exists) {
      await ref.set({
        'email': user.email,
        'name': user.email?.split('@')[0] ?? '',
        'role': 'patient', // default
        'clinicId': null, // will be updated later
        'createdAt': Timestamp.now(),
      });
    }
  }

  Future<String?> createClinicWithDetails({
    required String name,
    required String address,
    required String phone,
    required String adminName,
    required String adminPhone,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) return null;

      final ref = await _db.collection('clinics').add({
        'name': name,
        'address': address,
        'phone': phone,
        'adminId': user.uid,
        'createdAt': Timestamp.now(),
      });

      // ✅ global users doc with real admin name
      await _db.collection('users').doc(user.uid).set({
        'email': user.email,
        'name': adminName,
        'phone': adminPhone,
        'role': 'admin',
        'clinicId': ref.id,
      }, SetOptions(merge: true));

      // ✅ clinic subcollection with complete data
      await _db
          .collection('clinics')
          .doc(ref.id)
          .collection('users')
          .doc(user.uid)
          .set({
            'name': adminName,
            'email': user.email,
            'phone': adminPhone,
            'role': 'admin',
            'clinicId': ref.id,
            'createdAt': Timestamp.now(),
          });

      return ref.id;
    } catch (e) {
      debugPrint("Create clinic error: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> attachUserToClinic(String clinicId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    /// 🔹 clinic subcollection
    final clinicRef = _db
        .collection('clinics')
        .doc(clinicId)
        .collection('users')
        .doc(user.uid);

    final doc = await clinicRef.get();

    if (!doc.exists) {
      await clinicRef.set({
        'name': user.email?.split('@')[0] ?? '',
        'email': user.email,
        'phone': '',
        'role': 'patient',
        'clinicId': clinicId,
        'createdAt': Timestamp.now(),
      });
    }
    await _db.collection('users').doc(user.uid).update({'clinicId': clinicId});
  }

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
    context.read<UserBottomBarvm>().reset();
    context.read<AdminBottomBarvm>().reset();
    context.read<UserHomeViewModel>().reset();
    context.read<AdminHomeViewModel>().reset();
    context.read<AdminProfileVm>().reset();
    context.read<ClinicProvider>().reset();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  Future<String?> handleUser(BuildContext context) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final globalDoc = await _db.collection('users').doc(user.uid).get();
    if (!globalDoc.exists) {
      throw Exception("User data not found");
    }
    final data = globalDoc.data()!;
    final clinicId = data['clinicId'];
    final role = data['role'];
    debugPrint("✅ Role: $role");
    debugPrint("✅ ClinicId: $clinicId");

    if (clinicId == null) {
      throw Exception("No clinic assigned");
    }

    context.read<ClinicProvider>().setClinic(clinicId);

    return role;
  }
}
