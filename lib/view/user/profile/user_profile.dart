import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view/user/my_doctors/my_doctors.dart';
import 'package:room_rental/widgets/sectioncard.dart';
import 'package:room_rental/view_model/user/profile.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    Future.microtask(
      () => Provider.of<profileVM>(context, listen: false).getUserName(),
    );
    final navVM = context.read<userbotomVM>();
    return PopScope(
      canPop: navVM.selectedpage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navVM.selectedpage != 0) {
          navVM.changepage(0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Profile"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Consumer<profileVM>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(
                      "https://cdn.vectorstock.com/i/1000v/51/87/student-avatar-user-profile-icon-vector-47025187.jpg",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    vm.name.isEmpty ? "User Name" : vm.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  buildSectionCard(
                    children: [
                      buildTile(
                        Icons.person,
                        "Personal Information",
                        onTap: () {},
                      ),
                      buildTile(
                        Icons.description,
                        "Medical Records",
                        onTap: () {},
                      ),
                      buildTile(
                        Icons.history,
                        "Appointment History",
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  buildSectionCard(
                    children: [
                      buildTile(
                        Icons.people,
                        "My Doctors",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MyDoctorsPage()),
                          );
                        },
                      ),
                      buildTile(Icons.payment, "Payments", onTap: () {}),
                      buildTile(
                        Icons.notifications,
                        "Notifications",
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  buildSectionCard(
                    children: [
                      buildTile(
                        Icons.privacy_tip,
                        "Privacy & Policy",
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  buildSectionCard(
                    children: [
                      buildTile(
                        Icons.logout,
                        'Logout',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoleSelectionScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
