import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AppointmentViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  AppointmentViewModel(this.clinicProvider) {
    _init();
  }

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;
  bool showUpcoming = true;
  bool isCancelling = false;

  void _init() {
    if (clinicProvider.clinicId != null) {
      _listen();
    } else {
      clinicProvider.addListener(_wait);
    }
  }

  void _wait() {
    if (clinicProvider.clinicId != null) {
      clinicProvider.removeListener(_wait);
      _listen();
    }
  }

  void _listen() {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;
    if (user == null || cid == null) return;

    _db
        .collection('clinics')
        .doc(cid)
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .listen((snap) {
          appointments = snap.docs
              .map((e) => {'id': e.id, ...e.data()})
              .toList();
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
    return appointments.where((a) {
      final date = DateTime.tryParse(a['date'] ?? '');
      if (date == null) return false;
      return showUpcoming ? date.isAfter(now) : date.isBefore(now);
    }).toList();
  }

  Future<void> cancelBooking(String appointmentId, String reason) async {
    final user = FirebaseAuth.instance.currentUser;
    final cid = clinicProvider.clinicId;
    if (user == null || cid == null) return;

    try {
      isCancelling = true;
      notifyListeners();

      await _db
          .collection('clinics')
          .doc(cid)
          .collection('appointments')
          .doc(appointmentId)
          .update({
            'status': 'cancelled',
            'cancelReason': reason,
            'cancelledBy': 'user',
          });
    } catch (e) {
      debugPrint("Cancel error: $e");
    }

    isCancelling = false;
    notifyListeners();
  }
}
