import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClinicProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? clinicId;
  bool isLoading = true;

  Future<void> loadClinic() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    // STEP 1: check if ADMIN
    final adminSnap = await _db
        .collection('clinics')
        .where('adminId', isEqualTo: user.uid)
        .get();

    if (adminSnap.docs.isNotEmpty) {
      clinicId = adminSnap.docs.first.id;
    } else {
      // STEP 2: check inside users (for patient)
      final clinicsSnap = await _db.collection('clinics').get();

      for (var clinic in clinicsSnap.docs) {
        final userDoc = await _db
            .collection('clinics')
            .doc(clinic.id)
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          clinicId = clinic.id;
          break;
        }
      }
    }

    debugPrint("🔥 Loaded clinicId: $clinicId");

    isLoading = false;
    notifyListeners();
  }

  void setClinic(String id) {
    clinicId = id;
    notifyListeners();
  }

  void reset() {
    if (clinicId == null) return;
    clinicId = null;
    notifyListeners();
  }
}
