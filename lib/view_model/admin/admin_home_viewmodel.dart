import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = false;

  void fetchDoctors() {
    isLoading = true;
    notifyListeners();

    _firestore.collection('Doctors').snapshots().listen((snapshot) {
      doctors = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      isLoading = false;
      notifyListeners();
    });
  }

  Map<String, dynamic>? getDoctorById(String id) {
    try {
      return doctors.firstWhere((doc) => doc['id'] == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDoctor(String id, Map<String, dynamic> data) async {
    await _firestore.collection('Doctors').doc(id).update(data);
  }

  Future<void> deleteDoctor(String id) async {
    await _firestore.collection('Doctors').doc(id).delete();
  }
}
