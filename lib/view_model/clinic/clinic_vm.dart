import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClinicProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? clinicId;
  bool isLoading = true;

  /// 🔥 Call this after login
  Future<void> loadClinic() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      /// 🧠 STEP 1: Check if ADMIN
      final adminSnap = await _db
          .collection('clinics')
          .where('adminId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (adminSnap.docs.isNotEmpty) {
        clinicId = adminSnap.docs.first.id;

        debugPrint("👨‍⚕️ Admin clinicId: $clinicId");

        isLoading = false;
        notifyListeners();
        return;
      }

      /// 🧠 STEP 2: Otherwise check PATIENT
      final userSnap = await _db
          .collectionGroup('users')
          .where(FieldPath.documentId, isEqualTo: user.uid)
          .limit(1)
          .get();

      if (userSnap.docs.isNotEmpty) {
        final data = userSnap.docs.first.data();

        clinicId = data['clinicId'];

        debugPrint("👤 Patient clinicId: $clinicId");
      } else {
        debugPrint("❌ No clinic found for this user");
      }
    } catch (e) {
      debugPrint("🔥 Error loading clinic: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
