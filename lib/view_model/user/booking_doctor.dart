import 'package:cloud_firestore/cloud_firestore.dart';
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
    required String userName,
  }) async {
    if (selecteddate == null || selectedtime == null) return;

    await booking.collection('appointments').add({
      "doctorName": doctorName,
      "userName": userName,
      "date": selecteddate.toString(),
      "time": selectedtime,
      "status": "confirmed",
      "createdAt": Timestamp.now(),
    });
  }
}
