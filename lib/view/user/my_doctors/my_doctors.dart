import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/user/home/widgets/doctor_card.dart';
import 'package:room_rental/view_model/user/mydoctors.dart';

class MyDoctorsPage extends StatelessWidget {
  const MyDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyDoctorsViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text("My Doctors")),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : vm.myDoctors.isEmpty
          ? Center(child: Text("No bookings yet"))
          : ListView.builder(
              itemCount: vm.myDoctors.length,
              itemBuilder: (context, index) {
                final data = vm.myDoctors[index];
                return DoctorCard(
                  name: data['doctorName'] ?? '',
                  specialization: data['specialization'] ?? '',
                  rating: 4.5,
                  hospital: data['hospital'] ?? '',
                  imageUrl: data['image'] ?? '',
                );
              },
            ),
    );
  }
}
