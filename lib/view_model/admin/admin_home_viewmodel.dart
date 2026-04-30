import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeViewModel extends ChangeNotifier {
  AdminHomeViewModel() {
    _listenToDoctors();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;

  StreamSubscription? _subscription;

  void _listenToDoctors() {
    isLoading = true;
    notifyListeners();

    _subscription = _firestore
        .collection('Doctors')
        .snapshots()
        .listen(
          (snapshot) {
            doctors = snapshot.docs
                .map((doc) => {'id': doc.id, ...doc.data()})
                .toList();
            isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            isLoading = false;
            notifyListeners();
            debugPrint('Doctor stream error: $e');
          },
        );
  }

  Map<String, dynamic>? getDoctorById(String id) {
    try {
      return doctors.firstWhere((doc) => doc['id'] == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateDoctor(String id, Map<String, dynamic> data) async {
    await _firestore.collection('Doctors').doc(id).update(data);
  }

  Future<void> deleteDoctor(String id) async {
    await _firestore.collection('Doctors').doc(id).delete();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
