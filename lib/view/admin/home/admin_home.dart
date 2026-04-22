import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/add-screen/add_doctor.dart';
import 'package:room_rental/view/admin/widget/admin_doctorcard.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset('assets/role.png', height: 50, width: 50),
        ),
        title: const Text(
          "Vitality",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Clinical Oversight",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Manage doctors and medical staff easily",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      /// 🔹 ADD DOCTOR BUTTON
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddDoctorPage(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 6),
                              Text('Add Doctor'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Doctors Lists",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 🔥 DOCTORS LIST (PROVIDER)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: vm.doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = vm.doctors[index];

                          double rating = doctor['rating'] is double
                              ? doctor['rating']
                              : double.tryParse(doctor['rating'].toString()) ??
                                    0.0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AdminDoctorCard(
                              name: doctor['name'] ?? '',
                              specialization: doctor['specialization'] ?? '',
                              hospital: doctor['hospital'] ?? '',
                              rating: rating,
                              imageUrl: doctor['image'] ?? '',
                              docId: doctor['id'],
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Delete Doctor"),
                                    content: Text(
                                      "Are you sure you want to delete?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await context
                                              .read<HomeViewModel>()
                                              .deleteDoctor(doctor['id']);

                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Doctor deleted"),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
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
