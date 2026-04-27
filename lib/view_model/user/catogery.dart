import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;

  StreamSubscription? _subscription;

  void fetchDoctorsByCategory(String category) {
    _subscription?.cancel();

    _subscription = _firestore
        .collection('Doctors')
        .where('specialization', isEqualTo: category)
        .snapshots()
        .listen((snapshot) {
          doctors = snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();

          isLoading = false;
          notifyListeners();
        });
  }
}
