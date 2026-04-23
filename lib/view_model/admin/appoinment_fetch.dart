import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> appointments = [];

  int totalToday = 0;
  int pending = 0;
  int cancelled = 0;

  AdminDashboardViewModel() {
    fetchAppointments();
  }

  void fetchAppointments() {
    _firestore
        .collection('appointments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          appointments = snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();

          _calculateStats();
          notifyListeners();
        });
  }

  void _calculateStats() {
    totalToday = 0;
    pending = 0;
    cancelled = 0;

    final today = DateTime.now();

    for (var a in appointments) {
      final date = DateTime.tryParse(a['date'] ?? '');

      if (date != null &&
          date.day == today.day &&
          date.month == today.month &&
          date.year == today.year) {
        totalToday++;
      }

      if (a['status'] == 'pending') pending++;
      if (a['status'] == 'cancelled') cancelled++;
    }
  }

  /// 🔥 APPROVE
  Future<void> approve(String id) async {
    await _firestore.collection('appointments').doc(id).update({
      'status': 'confirmed',
    });
  }

  /// 🔥 CANCEL
  Future<void> cancel(String id) async {
    await _firestore.collection('appointments').doc(id).update({
      'status': 'cancelled',
    });
  }
}
