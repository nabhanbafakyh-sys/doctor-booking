import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/view/admin/edit_doctor/edit_doctor.dart';
import 'package:room_rental/view/doctor_details/widgets/widgets.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String docId;
  final bool isAdmin;

  const DoctorDetailsPage({
    super.key,
    required this.docId,
    this.isAdmin = false,
    required Map<String, Object> doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text(
          'Doctor Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // 🔥 LIVE DATA FROM FIRESTORE
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Doctors')
            .doc(docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(child: Text("Doctor not found"));
          }

          final doctor = snapshot.data!.data() as Map<String, dynamic>;

          // ✅ SAFE DATA
          final name = doctor['name']?.toString() ?? 'No Name';
          final specialization =
              doctor['specialization']?.toString() ?? 'No Specialization';
          final bio = doctor['bio']?.toString() ?? 'No bio available';

          // ✅ SAFE RATING
          double rating = doctor['rating'] is double
              ? doctor['rating']
              : double.tryParse(doctor['rating']?.toString() ?? '0') ?? 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // 👨‍⚕️ HEADER CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade700],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: const Icon(Icons.person, color: Colors.teal),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // ✅ visible
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialization,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📊 INFO CARDS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    infoCard("Experience", "5 yrs"),
                    infoCard("Patients", "500+"),
                    infoCard("Rating", rating.toStringAsFixed(1)),
                  ],
                ),

                const SizedBox(height: 20),

                // ⭐ RATING BAR
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "${rating.toStringAsFixed(1)}/5.0",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Patient Reviews",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📄 ABOUT
                sectionTitle("About Specialist"),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Text(
                      bio,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // 🔘 ADMIN EDIT BUTTON
      bottomNavigationBar: isAdmin
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditDoctorPage(docId: docId, data: {}),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Doctor"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
