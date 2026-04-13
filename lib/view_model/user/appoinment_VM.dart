import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  bool showUpcoming = true;

  void listenAppointments() {
    debugPrint("LISTENER STARTED");

    _db.collection('appointments').snapshots().listen((snapshot) {
      debugPrint("📦 DATA COUNT: ${snapshot.docs.length}");

      appointments = snapshot.docs.map((doc) => doc.data()).toList();
      appointments.sort(
        (a, b) => a['date'].toString().compareTo(b['date'].toString()),
      );

      isLoading = false;
      notifyListeners();
    });
  }

  void toggleTab(bool upcoming) {
    showUpcoming = upcoming;
    notifyListeners();
  }

  List<Map<String, dynamic>> get filteredAppointments {
    final now = DateTime.now();
    return appointments.where((appt) {
      try {
        final rawDate = appt['date'];
        if (rawDate == null) return false;
        final date = DateTime.parse(rawDate.toString().split(" ")[0]);
        final today = DateTime(now.year, now.month, now.day);
        final apptDate = DateTime(date.year, date.month, date.day);

        if (showUpcoming) {
          return apptDate.isAfter(today) || apptDate == today;
        } else {
          return apptDate.isBefore(today);
        }
      } catch (e) {
        debugPrint("Date error: $e");
        return false;
      }
    }).toList();
  }
}
