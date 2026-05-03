import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class ProfileVM extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  ProfileVM(this.clinicProvider) {
    loadUser();
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;

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
      nameController.text = data['name'] ?? "";
      emailController.text = data['email'] ?? "";
      phoneController.text = data['phone'] ?? "";
      notifyListeners();
    }
  }

  Future<void> updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;

    if (user == null || cid == null) return;

    try {
      isLoading = true;
      notifyListeners();

      await _db
          .collection('clinics')
          .doc(cid)
          .collection('users')
          .doc(user.uid)
          .update({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
          });
    } catch (e) {
      debugPrint("Update error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
