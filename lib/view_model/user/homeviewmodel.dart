import 'dart:async';
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
  bool initialized = false;

  StreamSubscription? _doctorsSubscription;

  void _loadAll() {
    fetchDoctors();
    fetchUser();
  }

  Future<void> init() async {
    debugPrint("init() called — clinicId: ${clinicProvider.clinicId}");
    if (initialized) return;
    initialized = true;
    if (clinicProvider.clinicId != null) {
      _loadAll();
    } else {
      debugPrint("clinicId is null, adding listener...");
      clinicProvider.addListener(onClinicReady);
    }
  }

  Future<void> onClinicReady() async {
    debugPrint("_onClinicReady fired — clinicId: ${clinicProvider.clinicId}");
    if (clinicProvider.clinicId != null) {
      clinicProvider.removeListener(onClinicReady);
      _loadAll();
    }
  }

  Future<void> fetchDoctors() async {
    final cid = clinicProvider.clinicId!;
    debugPrint("fetchDoctors() — fetching from clinics/$cid/doctors");

    _doctorsSubscription?.cancel();
    _doctorsSubscription = _db
        .collection('clinics')
        .doc(cid)
        .collection('doctors')
        .snapshots()
        .listen(
          (snap) {
            debugPrint("Snapshot received — ${snap.docs.length} doctors");
            doctors = snap.docs
                .map((e) => DoctorModel.fromFirestore(e.data(), e.id))
                .toList();
            filteredDoctors = doctors;
            notifyListeners();
          },
          onError: (e) {
            debugPrint("Firestore error: $e");
          },
        );
  }

  Future<void> fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;

    debugPrint("👤 Logged UID: ${user?.uid}");
    debugPrint("🏥 Clinic ID used: $cid");

    if (user == null || cid == null) return;

    final doc = await _db
        .collection('clinics')
        .doc(cid)
        .collection('users')
        .doc(user.uid)
        .get();

    debugPrint("📄 Doc exists: ${doc.exists}");
    debugPrint("📄 Doc ID fetched: ${doc.id}");
    debugPrint("📄 Data: ${doc.data()}");

    if (doc.exists) {
      userName = doc.data()?['name'] ?? "";
    }

    isLoading = false;
    notifyListeners();
  }

  void updateClinic(ClinicProvider newClinic) {
    if (newClinic.clinicId != clinicProvider.clinicId) {
      _loadAll();
    }
  }

  void search(String query) {
    filteredDoctors = query.isEmpty
        ? doctors
        : doctors
              .where(
                (d) =>
                    d.name.toLowerCase().contains(query.toLowerCase()) ||
                    d.specialization.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    notifyListeners();
  }

  void reset() {
    initialized = false;
    _doctorsSubscription?.cancel();
    clinicProvider.removeListener(onClinicReady);
    doctors = [];
    filteredDoctors = [];
    userName = "";
    isLoading = true;

    notifyListeners();

    init(); // re-run with the new user's clinicId
  }

  @override
  void dispose() {
    _doctorsSubscription?.cancel();
    clinicProvider.removeListener(onClinicReady);
    super.dispose();
  }
}
