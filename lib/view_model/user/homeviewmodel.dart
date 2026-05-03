import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_rental/model/doctor.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class UserHomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  UserHomeViewModel(this.clinicProvider);

  List<DoctorModel> doctors = [];
  List<DoctorModel> filteredDoctors = [];

  String userName = "";
  bool isLoading = true;

  void init() {
    if (clinicProvider.clinicId != null) {
      _loadAll();
    } else {
      clinicProvider.addListener(_onClinicReady);
    }
  }

  void _onClinicReady() {
    if (clinicProvider.clinicId != null) {
      clinicProvider.removeListener(_onClinicReady);
      _loadAll();
    }
  }

  void _loadAll() {
    fetchDoctors();
    fetchUser();
  }

  void fetchDoctors() {
    final cid = clinicProvider.clinicId!;
    _db.collection('clinics').doc(cid).collection('doctors').snapshots().listen(
      (snap) {
        doctors = snap.docs
            .map((e) => DoctorModel.fromFirestore(e.data(), e.id))
            .toList();

        filteredDoctors = doctors;
        notifyListeners();
      },
    );
  }

  Future<void> fetchUser() async {
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
      userName = data['name'] ?? "";
    }

    isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredDoctors = doctors;
    } else {
      filteredDoctors = doctors
          .where(
            (d) =>
                d.name.toLowerCase().contains(query.toLowerCase()) ||
                d.specialization.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
