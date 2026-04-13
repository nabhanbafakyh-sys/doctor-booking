import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = false;
  void fetchDoctors() {
    FirebaseFirestore.instance.collection('doctors').snapshots().listen((
      snapshot,
    ) {
      doctors = snapshot.docs.map((e) => e.data()).toList();
      notifyListeners();
    });
  }
}
