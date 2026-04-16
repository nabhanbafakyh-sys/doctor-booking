import 'package:flutter/material.dart';
import 'package:room_rental/model/doctor.dart';

class DoctorVM extends ChangeNotifier {
  List<DoctorModel> _allDoctors = [];

  List<dynamic> selectedCategory = [
    "general",
    "cardiologist",
    "pediatrics",
    "dental",
    "nuerology",
  ];

  void setDoctors(List<DoctorModel> doctors) {
    _allDoctors = doctors;
    notifyListeners();
  }

  List<DoctorModel> get filteredDoctors {
    return _allDoctors.where((doc) {
      return doc.specialization.toLowerCase() == selectedCategory;
    }).toList();
  }

  void selectCategory(String category) {
    selectedCategory = category as List<dynamic>;
    notifyListeners();
  }
}
