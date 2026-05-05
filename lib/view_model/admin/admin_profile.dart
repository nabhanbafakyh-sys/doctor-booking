import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AdminProfileVm extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  AdminProfileVm(this.clinicProvider) {
    _init();
  }

  bool isloading = true;
  String name = "";
  String email = "";
  String phone = "";
  String clinicName = "";
  String clinicAddress = "";
  String clinicPhone = "";

  void _init() {
    if (clinicProvider.clinicId != null) {
      loadUser();
    } else {
      clinicProvider.addListener(_onClinicReady);
      if (clinicProvider.clinicId != null) {
        clinicProvider.removeListener(_onClinicReady);
        loadUser();
      }
    }
  }

  void _onClinicReady() {
    if (clinicProvider.clinicId != null) {
      clinicProvider.removeListener(_onClinicReady);
      loadUser();
    }
  }

  Future<void> loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;

    if (user == null || cid == null) return;

    final results = await Future.wait([
      _db
          .collection('clinics')
          .doc(cid)
          .collection('users')
          .doc(user.uid)
          .get(),
      _db.collection('clinics').doc(cid).get(),
      _db.collection('users').doc(user.uid).get(),
    ]);

    final clinicUserDoc = results[0];
    final clinicDoc = results[1];
    final globalUserDoc = results[2];

    final userDoc = clinicUserDoc.exists ? clinicUserDoc : globalUserDoc;

    if (userDoc.exists) {
      final data = userDoc.data()!;
      name = data['name'] ?? "";
      email = data['email'] ?? "";
      phone = data['phone'] ?? "";
    }

    if (clinicDoc.exists) {
      final data = clinicDoc.data()!;
      clinicName = data['name'] ?? "";
      clinicAddress = data['address'] ?? "";
      clinicPhone = data['phone'] ?? "";
    }

    isloading = false;
    notifyListeners();
  }

  void reset() {
    clinicProvider.removeListener(_onClinicReady);
    name = "";
    email = "";
    phone = "";
    clinicName = "";
    clinicAddress = "";
    clinicPhone = "";
    isloading = true;
    notifyListeners();
    _init();
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
