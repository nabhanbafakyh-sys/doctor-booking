import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/widgets/doctor_card.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset('assets/role.png', height: 50, width: 50),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Vitality",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Clinical Oversight",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Manage doctors and medical staff easily",
                  style: TextStyle(color: Colors.grey),
                ),

                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 6),
                          Text('Add Doctor'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Doctors Lists",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Doctors')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final doctors = snapshot.data!.docs;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        final doc = doctors[index];
                        final data = doc.data();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Expanded(
                            child: DoctorCard(
                              name: data['name'] ?? '',
                              specialty: data['specialization'] ?? '',
                              rating: data['rating']?.toString() ?? '',
                              hospital: data['hospital'] ?? '',
                              imageUrl:
                                  data['image'] ??
                                  'https://cdn.vectorstock.com/i/1000v/51/87/student-avatar-user-profile-icon-vector-47025187.jpg',
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
