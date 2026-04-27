import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/model/doctor.dart';

class UserHomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DoctorModel> doctors = [];
  String userName = "User";
  bool isLoading = true;

  StreamSubscription? _doctorSub;
  StreamSubscription? _userSub;
  StreamSubscription? _authSub;

  UserHomeViewModel() {
    _listenToAuth();
    fetchdoctors();
  }

  /// 🔥 Listen to login/logout
  void _listenToAuth() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _userSub?.cancel();

      /// 🔥 reset user data
      userName = "User";
      notifyListeners();

      if (user != null) {
        listenUser(user.uid);
      }
    });
  }

  void fetchdoctors() {
    _firestore.collection('Doctors').snapshots().listen((snapshot) {
      doctors = snapshot.docs.map((doc) {
        return DoctorModel.fromFirestore(doc.data(), doc.id);
      }).toList();

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

  @override
  void dispose() {
    _doctorSub?.cancel();
    _userSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
