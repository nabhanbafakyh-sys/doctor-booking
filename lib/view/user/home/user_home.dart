import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:room_rental/view_model/user/homeviewmodel.dart';
import 'package:room_rental/widgets/catogery.dart';
import 'package:room_rental/view/user/home/widgets/doctor_card.dart';
import 'package:room_rental/view/user/catogeries/cotogeryfilter.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserHomeViewModel>();
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
                Text(
                  "Hello, ${vm.userName} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),

                SizedBox(height: 5),
                Text(
                  'Find your doctor',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 20),
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

                /// 🔹 CATEGORIES
                const Text(
                  "Departments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 10),

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
                        icon: FontAwesomeIcons.baby,
                        label: 'pediatrics',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'pediatrics'),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.tooth,
                        label: 'dental',
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
                      CategoryItem(
                        icon: FontAwesomeIcons.brain,
                        label: 'nuerology',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'nuerology'),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.heart,
                        label: 'cardiology',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'cardiology'),
                            ),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.stethoscope,
                        label: 'medicine',
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryDoctorsScreen(category: 'medicine'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 DOCTORS LIST
                const Text(
                  "Our Doctors",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                const SizedBox(height: 10),

                vm.doctors.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: vm.doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = vm.doctors[index];

                          return DoctorCard(
                            doctor: doctor, // ✅ pass full model
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
