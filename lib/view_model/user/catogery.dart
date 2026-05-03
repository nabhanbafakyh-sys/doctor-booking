import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  CategoryViewModel(this.clinicProvider);

  List<Map<String, dynamic>> doctors = [];
  bool isloading = true;

  Future<void> fetchDoctorsByCategory(String category) async {
    final cid = clinicProvider.clinicId;
    if (cid == null) return;

    _db
        .collection('clinics')
        .doc(cid)
        .collection('doctors')
        .where('specialization', isEqualTo: category)
        .snapshots()
        .listen((snap) {
          doctors = snap.docs.map((e) => {'id': e.id, ...e.data()}).toList();
          notifyListeners();
        });
  }
}
