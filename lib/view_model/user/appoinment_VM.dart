import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  bool showUpcoming = true;

  StreamSubscription? _appointmentSub;
  StreamSubscription? _authSub;

  AppointmentViewModel() {
    _listenToAuth();
  }

  void _listenToAuth() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _appointmentSub?.cancel();

      appointments = [];
      isLoading = true;
      notifyListeners();

      if (user != null) {
        Appointments(user.uid); // ✅ fixed
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // Listen to appointments of current user
  void Appointments(String userId) {
    isLoading = true;
    notifyListeners();

    _appointmentSub = _db
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
          appointments = snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();

          appointments.sort((a, b) {
            final dateA = DateTime.parse(a['date']);
            final dateB = DateTime.parse(b['date']);
            return dateA.compareTo(dateB);
          });

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

        final apptDate = DateTime.parse(rawDate);

        if (showUpcoming) {
          return !apptDate.isBefore(now);
        } else {
          return apptDate.isBefore(now);
        }
      } catch (e) {
        debugPrint("Date error: $e");
        return false;
      }
    }).toList();
  }

  @override
  void dispose() {
    _appointmentSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
