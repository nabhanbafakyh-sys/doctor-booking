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

  Future<void> _listenToAuth() async {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _appointmentSub?.cancel();

      appointments = [];
      isLoading = true;
      notifyListeners();

      if (user != null) {
        Appointments(user.uid);
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // Listen to appointments of current user
  Future<void> Appointments(String userId) async {
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
    final today = DateTime(now.year, now.month, now.day);

    return appointments.where((appt) {
      try {
        final rawDate = appt['date'];
        if (rawDate == null) return false;

        final parsed = DateTime.parse(rawDate);
        final apptDate = DateTime(parsed.year, parsed.month, parsed.day);

        if (showUpcoming) {
          return apptDate.isAtSameMomentAs(today) || apptDate.isAfter(today);
        } else {
          return apptDate.isBefore(today);
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
