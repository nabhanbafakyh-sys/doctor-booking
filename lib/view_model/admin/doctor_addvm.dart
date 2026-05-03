import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class DoctorViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  DoctorViewModel(this.clinicProvider);

  bool isLoading = false;

  Future<void> addDoctor({
    required String name,
    required String specialization,
    required String hospital,
    required String rating,
    required String bio,
  }) async {
    final cid = clinicProvider.clinicId;
    if (cid == null) return;

    isLoading = true;
    notifyListeners();

    await _db.collection('clinics').doc(cid).collection('doctors').add({
      'name': name,
      'specialization': specialization,
      'hospital': hospital,
      'rating': double.tryParse(rating) ?? 0,
      'bio': bio,
      'createdAt': FieldValue.serverTimestamp(),
    });

    isLoading = false;
    notifyListeners();
  }
}
