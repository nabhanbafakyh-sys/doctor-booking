import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> doctors = [];
  bool isLoading = true;

  void fetchDoctorsByCategory(String category) {
    isLoading = true;
    notifyListeners();

    _firestore
        .collection('Doctors')
        .where('specialization', isEqualTo: category)
        .snapshots()
        .listen((snapshot) {
          debugPrint("TOTAL DOCS FROM FIRESTORE: ${snapshot.docs.length}");

          for (var doc in snapshot.docs) {
            debugPrint("DOC DATA: ${doc.data()}");
          }

          doctors = snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();

          isLoading = false;
          notifyListeners();
        });
  }
}
