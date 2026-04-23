import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/edit_doctor/edit_doctor.dart';
import 'package:room_rental/view/doctor_details/widgets/widgets.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String docId;
  final bool isAdmin;

  const DoctorDetailsPage({
    super.key,
    required this.docId,
    this.isAdmin = false,
    required Map<String, Object> data,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminHomeViewModel>();

    final doctorList = vm.doctors.where((d) => d['id'] == docId).toList();

    if (doctorList.isEmpty) {
      return const Scaffold(body: Center(child: Text("Doctor not found")));
    }

    final doctor = doctorList[0];

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔹 IMAGE + BACK BUTTON
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: Image.network(
                    doctor['image'] ?? '',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      height: 300,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 80),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 NAME + SPECIALIZATION
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    doctor['specialization'] ?? '',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 INFO CARDS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                infoCard("Experience", "5 yrs"),
                infoCard("Patients", "500+"),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔹 RATING
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${doctor['rating'] ?? '0'}/5.0",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      SizedBox(width: 5),
                      Text("(Reviews)", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            sectionTitle("About Specialist"),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  doctor['bio'] ?? "No bio available",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: isAdmin
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditDoctorPage(docId: docId, data: doctor),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Doctor"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
