import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ClinicProvider clinicProvider;

  AdminDashboardViewModel(this.clinicProvider) {
    _init();
  }

  List<Map<String, dynamic>> appointments = [];
  int totalToday = 0;
  int pending = 0;
  int cancelled = 0;

  StreamSubscription? _subscription;

  void _init() {
    if (clinicProvider.clinicId != null) {
      _listenToAppointments();
    } else {
      clinicProvider.addListener(_waitForClinic);
    }
  }

  void _waitForClinic() {
    if (clinicProvider.clinicId != null) {
      clinicProvider.removeListener(_waitForClinic);
      _listenToAppointments();
    }
  }

  void _listenToAppointments() {
    final cid = clinicProvider.clinicId!;
    _subscription = _firestore
        .collection('clinics')
        .doc(cid)
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            appointments = snapshot.docs
                .map((doc) => {'id': doc.id, ...doc.data()})
                .toList();
            _calculateStats();
            notifyListeners();
          },
          onError: (e) {
            debugPrint('Appointment stream error: $e');
          },
        );
  }

  void _calculateStats() {
    final today = DateTime.now();
    totalToday = 0;
    pending = 0;
    cancelled = 0;

    for (final a in appointments) {
      DateTime? date;
      if (a['date'] is String) {
        date = DateTime.tryParse(a['date']);
      } else if (a['date'] is Timestamp) {
        date = (a['date'] as Timestamp).toDate();
      }

      if (date != null &&
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day) {
        totalToday++;
      }

      if (a['status'] == 'pending') pending++;
      if (a['status'] == 'cancelled') cancelled++;
    }
  }

  Future<void> approve(String id) async {
    final cid = clinicProvider.clinicId;
    if (cid == null) return;

    await _firestore
        .collection('clinics')
        .doc(cid)
        .collection('appointments')
        .doc(id)
        .update({'status': 'confirmed'});
  }

  Future<void> cancel(String id, String reason) async {
    final cid = clinicProvider.clinicId;
    if (cid == null) return;

    await _firestore
        .collection('clinics')
        .doc(cid)
        .collection('appointments')
        .doc(id)
        .update({
          'status': 'cancelled',
          'cancelReason': reason,
          'cancelledBy': 'admin',
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
