import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDoctorsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> myDoctors = [];
  bool isLoading = true;

  void fetchMyDoctors() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    _firestore
        .collection('Bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
          myDoctors = snapshot.docs.map((doc) => doc.data()).toList();

          isLoading = false;
          notifyListeners(); // 🔥 auto update UI
        });
  }
}
