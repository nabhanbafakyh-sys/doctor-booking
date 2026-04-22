import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/view/user/home/widgets/doctor_card.dart';

class CategoryDoctorsScreen extends StatelessWidget {
  final String category;

  const CategoryDoctorsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Doctors')
            .where('specialization', isEqualTo: category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No doctors found"));
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index].data();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DoctorCard(
                  name: doctor['name'] ?? '',
                  specialization: doctor['specialization'] ?? '',
                  rating: doctor['rating'],
                  hospital: doctor['hospital'] ?? '',
                  imageUrl: doctor['image'] ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
