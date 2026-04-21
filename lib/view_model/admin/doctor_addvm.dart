import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<void> addDoctor({
    required String name,
    required String specialization,
    required String hospital,
    required String rating,
    required String bio,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _firestore.collection('Doctors').add({
        'name': name,
        'specialization': specialization,
        'hospital': hospital,
        'rating': rating,
        'bio': bio,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error adding doctor: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
