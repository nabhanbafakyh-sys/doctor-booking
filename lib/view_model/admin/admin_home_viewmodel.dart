import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AdminHomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  AdminHomeViewModel(this.clinicProvider) {
    _init();
  }

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;

  StreamSubscription? _sub;

  void _init() {
    if (clinicProvider.clinicId != null) {
      _listen();
    } else {
      clinicProvider.addListener(_waitForClinic);
    }
  }

  void _waitForClinic() {
    if (clinicProvider.clinicId != null) {
      clinicProvider.removeListener(_waitForClinic);
      _listen();
    }
  }

  void _listen() {
    final id = clinicProvider.clinicId!;
    _sub = _db
        .collection('clinics')
        .doc(id)
        .collection('doctors')
        .snapshots()
        .listen((snap) {
          doctors = snap.docs.map((e) => {'id': e.id, ...e.data()}).toList();
          isLoading = false;
          notifyListeners();
        });
  }

  Future<void> deleteDoctor(String id) async {
    final cid = clinicProvider.clinicId;
    if (cid == null) return;

    await _db
        .collection('clinics')
        .doc(cid)
        .collection('doctors')
        .doc(id)
        .delete();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
