import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class BookingVM extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  BookingVM(this.clinicProvider);

  DateTime? selectedDate;
  String? selectedTime;

  void pickdate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void pickTime(String time) {
    if (selectedTime == time) {
      selectedTime = null; // toggle off
    } else {
      selectedTime = time;
    }
    notifyListeners();
  }

  Future<String> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String specialty,
    required String hospital,
    required String image,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;
    if (user == null || cid == null) return "Error";
    if (selectedDate == null || selectedTime == null) {
      return "Please select date and time";
    }

    final userDoc = await _db
        .collection('clinics')
        .doc(cid)
        .collection('users')
        .doc(user.uid)
        .get();

    final userName = userDoc.data()?['name'] ?? "User";

    final dateStr = selectedDate!.toIso8601String();

    // 🔥 Prevent double booking
    final existing = await _db
        .collection('clinics')
        .doc(cid)
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('date', isEqualTo: dateStr)
        .where('time', isEqualTo: selectedTime)
        .get();

    if (existing.docs.isNotEmpty) {
      return "Slot already booked";
    }

    await _db.collection('clinics').doc(cid).collection('appointments').add({
      'userId': user.uid,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'userName': userName,
      'date': dateStr,
      'time': selectedTime,
      'status': "pending",
      'createdAt': Timestamp.now(),
    });

    return "success";
  }
}
