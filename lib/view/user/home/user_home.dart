import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:room_rental/view/user/catogeries/general.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';
import 'package:room_rental/widgets/catogery.dart';
import 'package:room_rental/widgets/doctor_card.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeViewModel>().fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.person_2_outlined),
        ),
        title: Text(
          'Vitality',
          style: TextStyle(
            color: Colors.blue[400],
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications, color: Colors.blue[400]),
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
                  'Hello, User ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
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
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_outlined),
                      hintText: 'Search your doctor, specialties',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
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
                            MaterialPageRoute(builder: (context) => General()),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.heartPulse,
                        label: 'Cardio',
                        ontap: () {},
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.brain,
                        label: 'Neuro',
                        ontap: () {},
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.tooth,
                        label: 'Dental',
                        ontap: () {},
                      ),
                      CategoryItem(
                        icon: FontAwesomeIcons.faceSmile,
                        label: 'Pediatrics',
                        ontap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Our Doctors,",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Doctors')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // 🔄 Loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // ❌ Error
                    if (snapshot.hasError) {
                      return Center(child: Text("Something went wrong"));
                    }

                    // 📭 No Data
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text("No doctors found"));
                    }

                    final doctors = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true, // ✅ IMPORTANT
                      physics: NeverScrollableScrollPhysics(), // ✅ IMPORTANT
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctors[index].data();

                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: DoctorCard(
                              name: doctor['name'] ?? '',
                              specialty: doctor['specialization'] ?? '',
                              rating: doctor['rating'] ?? '',
                              hospital: doctor['hospital'] ?? "",
                              imageUrl: '',
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
