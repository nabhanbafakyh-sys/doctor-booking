import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserHomeViewModel extends ChangeNotifier {
  UserHomeViewModel() {
    fetchDoctors();
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  String userName = "User";

  void fetchDoctors() {
    _firestore.collection('Doctors').snapshots().listen((snapshot) {
      doctors = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      notifyListeners();
    });
  }

  void fetchUser(String userId) {
    _firestore.collection('Users').doc(userId).snapshots().listen((doc) {
      if (doc.exists) {
        userName = doc['name'] ?? "User";
        notifyListeners();
      }
    });
  }
}
