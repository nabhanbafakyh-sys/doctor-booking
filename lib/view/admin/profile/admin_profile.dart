import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/add-screen/add_doctor.dart';
import 'package:room_rental/view/admin/appoinment_history/history.dart';
import 'package:room_rental/view/admin/doctors_list/doctors_list.dart';
import 'package:room_rental/view/admin/profile/admin_info.dart';
import 'package:room_rental/view_model/auth/auth.dart';
import 'package:room_rental/widgets/sectioncard.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Admin Panel'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            buildSectionCard(
              children: [
                buildTile(
                  Icons.person,
                  "Admin Info",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminInfo()),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10),

            buildSectionCard(
              children: [
                buildTile(Icons.dashboard, "Dashboard", onTap: () {}),
                buildTile(Icons.bar_chart, "Reports", onTap: () {}),
              ],
            ),

            SizedBox(height: 10),

            buildSectionCard(
              children: [
                buildTile(
                  Icons.history,
                  "Appointment History",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminAppointmentHistory(),
                      ),
                    );
                  },
                ),
                buildTile(
                  Icons.people,
                  "Manage Doctors",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDoctorsScreen(),
                      ),
                    );
                  },
                ),
                buildTile(
                  Icons.add,
                  "Add Doctor",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddDoctorPage()),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10),

            buildSectionCard(
              children: [
                buildTile(Icons.notifications, "Notifications", onTap: () {}),
                buildTile(Icons.settings, "Settings", onTap: () {}),
              ],
            ),

            SizedBox(height: 10),

            buildSectionCard(
              children: [
                buildTile(
                  Icons.logout,
                  'Log out',
                  onTap: () {
                    context.read<AuthViewModel>().logout(context);
                  },
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
