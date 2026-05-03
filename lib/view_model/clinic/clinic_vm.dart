import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClinicProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? clinicId;
  bool isLoading = true;

  Future<void> loadClinic() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    final snapshot = await _db
        .collection('clinics')
        .where('adminId', isEqualTo: uid)
        .get();

    if (snapshot.docs.isNotEmpty) {
      clinicId = snapshot.docs.first.id;
    }

    isLoading = false;
    notifyListeners();
  }
}
