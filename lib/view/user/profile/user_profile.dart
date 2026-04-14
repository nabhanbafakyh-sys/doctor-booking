import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

                buildTile(Icons.calendar_today, "My Appointments"),
                buildTile(Icons.favorite, "Favorite Doctors"),
                buildTile(Icons.notifications, "Notifications"),
                buildTile(Icons.settings, "Settings"),
                SizedBox(height: 20),
                buildTile(Icons.logout, "Logout", isLogout: true),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 Reusable Tile
  Widget buildTile(IconData icon, String title, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.teal),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (title == "Logout") {
            // TODO: Firebase logout
          }
        },
      ),
    );
  }
}
