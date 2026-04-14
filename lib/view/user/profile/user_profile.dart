import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view/user/profile/widget/tile.dart';
import 'package:room_rental/view_model/user/profile.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Call API (only once safely)
    Future.microtask(
      () => Provider.of<profileVM>(context, listen: false).getUserName(),
    );

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Consumer<profileVM>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Text(
                  vm.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),

                buildTile(
                  context,
                  Icons.calendar_today,
                  "My Appointments",
                  onTap: () {},
                ),
                buildTile(
                  context,
                  Icons.favorite,
                  "Favorite Doctors",
                  onTap: () {},
                ),
                buildTile(
                  context,
                  Icons.notifications,
                  "Notifications",
                  onTap: () {},
                ),
                buildTile(context, Icons.settings, "Settings", onTap: () {}),
                SizedBox(height: 20),
                buildTile(
                  context,
                  Icons.logout,
                  "Logout",
                  onTap: () async {
                    // 🔹 Navigate to Role Screen (force)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RoleSelectionScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
