import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookingVM extends ChangeNotifier {
  DateTime? selecteddate;
  String? selectedtime;

  final FirebaseFirestore booking = FirebaseFirestore.instance;

  void pickdate(DateTime date) {
    selecteddate = date;
    notifyListeners();
  }

  void picktime(String time) {
    selectedtime = time;
    notifyListeners();
  }

  Future<void> bookAppointment({
    required String doctorName,
    required String specialty,
  }) async {
    try {
      if (selecteddate == null || selectedtime == null) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data();
      final userName = userData?['name'] ?? "User";
      await booking.collection('appointments').add({
        'userId': user.uid,
        'doctorName': doctorName,
        'specialization': specialty,
        'userName': userName,
        'date': selecteddate!.toIso8601String(),
        'time': selectedtime,
        'status': "confirmed",
        'createdAt': Timestamp.now(),
      });

      debugPrint("Appointment booked successfully");
    } catch (e) {
      debugPrint("Booking error: $e");
    }
  }
}
