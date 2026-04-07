import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = false;

  bool showUpcoming = true;

  Future<void> fetchAppointments() async {
    isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _db.collection('appointments').get();

      appointments = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleTab(bool upcoming) {
    showUpcoming = upcoming;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredAppointments {
    final now = DateTime.now();

    return appointments.where((appt) {
      final date = DateTime.tryParse(appt['date'] ?? '');

      if (date == null) return false;

      if (showUpcoming) {
        return date.isAfter(now) || date.isAtSameMomentAs(now);
      } else {
        return date.isBefore(now);
      }
    }).toList();
  }
}
