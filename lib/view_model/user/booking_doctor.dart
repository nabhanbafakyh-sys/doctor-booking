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

  Future<String> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String specialty,
    required String hospital,
    required String image,
  }) async {
    try {
      if (selecteddate == null || selectedtime == null) {
        return "Please select date & time";
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return "User not logged in";

      final userDoc = await booking.collection('users').doc(user.uid).get();
      final userName = userDoc.data()?['name'] ?? "User";
      final userData = userDoc.data();
      final userPhone = userData?['phone'] ?? "";
      final dateStr = selecteddate!.toIso8601String();

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final query = await booking
            .collection('appointments')
            .where('doctorId', isEqualTo: doctorId)
            .where('date', isEqualTo: dateStr)
            .where('time', isEqualTo: selectedtime)
            .get();

        if (query.docs.isNotEmpty) {
          throw Exception("Slot already booked");
        }

        final newDoc = booking.collection('appointments').doc();

        transaction.set(newDoc, {
          'userId': user.uid,
          'doctorId': doctorId,
          'doctorName': doctorName,
          'specialization': specialty,
          'hospital': hospital,
          'image': image,
          'userName': userName,
          'userPhone': userPhone,
          'date': dateStr,
          'time': selectedtime,
          'status': "pending",
          'createdAt': Timestamp.now(),
        });
      });

      return "success";
    } catch (e) {
      return e.toString();
    }
  }
}
