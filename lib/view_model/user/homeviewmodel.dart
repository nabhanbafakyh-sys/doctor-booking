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
    _listenToAuth();
    fetchDoctors();
  }

  void _listenToAuth() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _userSub?.cancel();

      userName = "User";
      notifyListeners();

      if (user != null) {
        listenUser(user.uid);
      }
    });
  }

  void fetchDoctors() {
    _firestore.collection('Doctors').snapshots().listen((snapshot) {
      doctors = snapshot.docs.map((doc) {
        return DoctorModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      filteredDoctors = doctors;

      notifyListeners();
    });
  }

  void listenUser(String userId) {
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

  void searchDoctors(String query) {
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
  void dispose() {
    _doctorSub?.cancel();
    _userSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
