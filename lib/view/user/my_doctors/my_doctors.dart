import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/model/doctor.dart';
import 'package:room_rental/view/user/home/widgets/doctor_card.dart';
import 'package:room_rental/view_model/user/mydoctors.dart';

class MyDoctorsPage extends StatelessWidget {
  const MyDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyDoctorsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Doctors"), centerTitle: true),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.myDoctors.isEmpty) {
            return const Center(
              child: Text(
                "No bookings yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.myDoctors.length,
            itemBuilder: (context, index) {
              final data = vm.myDoctors[index];

              final doctor = DoctorModel(
                name: data['doctorName'] ?? '',
                specialization: data['specialization'] ?? '',
                hospital: data['hospital'] ?? '',
                rating: 4.5,
                image: data['image'] ?? '',
                id: '',
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DoctorCard(doctor: doctor),
              );
            },
          );
        },
      ),
    );
  }
}
