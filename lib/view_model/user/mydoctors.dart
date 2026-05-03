import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class MyDoctorsViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;
  bool isloading = true;
  MyDoctorsViewModel(this.clinicProvider);
  List<Map<String, dynamic>> myDoctors = [];

  void init() {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;

    if (user == null || cid == null) return;

    _db
        .collection('clinics')
        .doc(cid)
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snap) {
          myDoctors = snap.docs.map((e) => {'id': e.id, ...e.data()}).toList();
          notifyListeners();
        });
  }
}
