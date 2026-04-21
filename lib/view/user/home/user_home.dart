import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:room_rental/view/user/catogeries/cotogeryfilter.dart';
import 'package:room_rental/widgets/catogery.dart';
import 'package:room_rental/widgets/doctor_card.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.person_2_outlined, color: Colors.teal.shade300),
        ),
        title: Text(
          'Vitality',
          style: TextStyle(
            color: Colors.teal.shade300,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications, color: Colors.teal.shade300),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 👤 USERNAME FROM FIREBASE
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text(
                        "Hello, User",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>?;

                    final name = data?['name'] ?? "User";

                    return Text(
                      "Hello, $name 👋",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 5),

                const Text(
                  'Find your doctor',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// 🔍 SEARCH BAR
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined),
                      hintText: 'Search your doctor, specialties',
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🏥 CATEGORY TITLE
                const Text(
                  "Departments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 10),

                /// 📂 CATEGORY LIST
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryItem(
                        icon: FontAwesomeIcons.hospital,
                        label: 'General',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'general'),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.heartPulse,
                        label: 'Cardio',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryDoctorsScreen(
                                category: 'cardiologist',
                              ),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.brain,
                        label: 'Neuro',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'neurology'),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.tooth,
                        label: 'Dental',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'dental'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 👨‍⚕️ DOCTORS TITLE
                const Text(
                  "Our Doctors",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                const SizedBox(height: 10),

                /// 👨‍⚕️ DOCTORS LIST
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Doctors')
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
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor =
                            doctors[index].data() as Map<String, dynamic>;

                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: DoctorCard(
                              name: doctor['name'] ?? '',
                              specialty: doctor['specialization'] ?? '',
                              rating: doctor['rating'] ?? '',
                              hospital: doctor['hospital'] ?? "",
                              imageUrl:
                                  'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
