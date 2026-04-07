import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = false;

  Future<void> fetchAppointments() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _db.collection('appointments').get();

      appointments = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching appointments: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
