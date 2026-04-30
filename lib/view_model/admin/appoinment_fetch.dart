import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  AdminDashboardViewModel() {
    _listenToAppointments();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> appointments = [];
  int totalToday = 0;
  int pending = 0;
  int cancelled = 0;

  StreamSubscription? _subscription;

  void _listenToAppointments() {
    _subscription = _firestore
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

  // Sync — no need for async
  void _calculateStats() {
    final today = DateTime.now();
    totalToday = 0;
    pending = 0;
    cancelled = 0;

    for (final a in appointments) {
      final date = DateTime.tryParse(a['date'] ?? '');
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
    await _firestore.collection('appointments').doc(id).update({
      'status': 'confirmed',
    });
  }

  Future<void> cancel(String id) async {
    await _firestore.collection('appointments').doc(id).update({
      'status': 'cancelled',
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
