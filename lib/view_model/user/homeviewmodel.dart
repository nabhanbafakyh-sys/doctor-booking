import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/model/doctor.dart';

class UserHomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DoctorModel> filteredDoctors = [];
  List<DoctorModel> doctors = [];
  String userName = "User";
  bool isLoading = true;

  StreamSubscription? _doctorSub;
  StreamSubscription? _userSub;
  StreamSubscription? _authSub;

  UserHomeViewModel() {
    listenToAuth();
    fetchDoctors();
  }

  Future<void> listenToAuth() async {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _userSub?.cancel();

      userName = "User";
      notifyListeners();

      if (user != null) {
        listenUser(user.uid);
      }
    });
  }

  Future<void> fetchDoctors() async {
    _firestore.collection('Doctors').snapshots().listen((snapshot) {
      doctors = snapshot.docs.map((doc) {
        return DoctorModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      filteredDoctors = doctors;

      notifyListeners();
    });
  }

  Future listenUser(String userId) async {
    _userSub = _firestore.collection('Users').doc(userId).snapshots().listen((
      doc,
    ) {
      if (doc.exists) {
        userName = doc['name'] ?? "User";
      } else {
        userName = "User";
      }
      notifyListeners();
    });
  }

  Future searchDoctors(String query) async {
    if (query.isEmpty) {
      filteredDoctors = doctors;
    } else {
      final q = query.toLowerCase();

      filteredDoctors = doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(q) ||
            doctor.specialization.toLowerCase().contains(q) ||
            doctor.hospital.toLowerCase().contains(q);
      }).toList();
    }

    notifyListeners();
  }

  @override
  Future dispose() async {
    _doctorSub?.cancel();
    _userSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
