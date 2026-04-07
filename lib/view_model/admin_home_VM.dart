import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = false;

  Future<void> fetchDoctors() async {
    isLoading = true;
    notifyListeners();

    final snapshot = await _db.collection('Doctors').get();

    debugPrint(" Docs count: ${snapshot.docs.length}");

    doctors = snapshot.docs.map((doc) => doc.data()).toList();

    debugPrint(" Data: $doctors");

    isLoading = false;
    notifyListeners();
  }
}
