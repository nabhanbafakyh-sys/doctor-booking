import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/model/doctor.dart';
import 'package:room_rental/view/user/home/widgets/doctor_card.dart';
import 'package:room_rental/view_model/user/catogery.dart';

class CategoryDoctorsScreen extends StatelessWidget {
  final String category;

  const CategoryDoctorsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CategoryViewModel()..fetchDoctorsByCategory(category), // 🔥 IMPORTANT
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(category),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Consumer<CategoryViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (vm.doctors.isEmpty) {
              return Center(child: Text("No doctors found"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.doctors.length,
              itemBuilder: (context, index) {
                final data = vm.doctors[index];

                double rating = data['rating'] is double
                    ? data['rating']
                    : double.tryParse(data['rating'].toString()) ?? 0.0;

                final doctor = DoctorModel(
                  id: data['id'] ?? '',
                  name: data['name'] ?? '',
                  specialization: data['specialization'] ?? '',
                  hospital: data['hospital'] ?? '',
                  rating: rating,
                  image: data['image'] ?? '',
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DoctorCard(doctor: doctor),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
