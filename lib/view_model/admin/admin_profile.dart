import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AdminProfileVm extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  AdminProfileVm(this.clinicProvider) {
    loadUser();
  }
  bool isloading = true;
  String name = "";
  String email = "";
  String phone = "";

  Future<void> loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;

    if (user == null || cid == null) return;

    final doc = await _db
        .collection('clinics')
        .doc(cid)
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      name = data['name'] ?? "";
      email = data['email'] ?? "";
      phone = data['phone'] ?? "";
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;

    if (user == null || cid == null) return;

    try {
      isloading = true;
      notifyListeners();

      await _db
          .collection('clinics')
          .doc(cid)
          .collection('users')
          .doc(user.uid)
          .update({'name': newName, 'email': newEmail, 'phone': newPhone});

      // update local state
      name = newName;
      email = newEmail;
      phone = newPhone;
    } catch (e) {
      debugPrint("Update profile error: $e");
    }

    isloading = false;
    notifyListeners();
  }
}
