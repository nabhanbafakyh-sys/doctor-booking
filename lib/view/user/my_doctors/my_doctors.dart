import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room_rental/view/user/home/widgets/doctor_card.dart';

class MyDoctorsPage extends StatelessWidget {
  const MyDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Doctors")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Bookings')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return const Center(child: Text("No bookings yet"));
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index].data();

              return DoctorCard(
                name: data['doctorName'] ?? '',
                specialization: data['specialization'] ?? '',
                rating: 4.5, // optional default
                hospital: data['hospital'] ?? '',
                imageUrl: data['image'] ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
