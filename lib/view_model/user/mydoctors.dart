import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDoctorsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> myDoctors = [];
  bool isLoading = true;

  StreamSubscription? _subscription;

  MyDoctorsViewModel() {
    listenToAuth();
  }

  Future listenToAuth() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        fetchMyDoctors(user.uid);
      } else {
        myDoctors = [];
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // Fetch appointments
  Future fetchMyDoctors(String userId) async {
    _subscription?.cancel();

    isLoading = true;
    notifyListeners();

    _subscription = _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            myDoctors = snapshot.docs.map((doc) {
              return {'id': doc.id, ...doc.data()};
            }).toList();

            // Sort by date
            myDoctors.sort((a, b) {
              final dateA = DateTime.parse(a['date']);
              final dateB = DateTime.parse(b['date']);
              return dateA.compareTo(dateB);
            });

            isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            debugPrint("Error fetching appointments: $e");
            isLoading = false;
            notifyListeners();
          },
        );
  }

  // Cancel appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
    } catch (e) {
      debugPrint("Cancel error: $e");
    }
  }

  bool get hasData => myDoctors.isNotEmpty;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
