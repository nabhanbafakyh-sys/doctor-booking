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
        scrolledUnderElevation: 0,
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
          padding: EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${vm.userName} ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),

                SizedBox(height: 5),
                Text(
                  'Find your doctor',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[300],
                  ),
                  child: TextField(
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined),
                      hintText: 'Search your doctor, specialties',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      context.read<UserHomeViewModel>().searchDoctors(value);
                    },
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  "Departments",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                SizedBox(height: 10),

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
                        label: 'neurology',
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

                SizedBox(height: 20),
                Text(
                  "Our Doctors",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                SizedBox(height: 10),
                vm.filteredDoctors.isEmpty
                    ? Center(child: Text("No doctors found"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: vm.filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = vm.filteredDoctors[index];

                          return DoctorCard(doctor: doctor);
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
