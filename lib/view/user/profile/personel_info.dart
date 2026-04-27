import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/user/profile/edit_profile.dart';
import 'package:room_rental/view_model/user/profile.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Personal Information"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Consumer<ProfileVM>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundImage: NetworkImage(
                            "https://cdn.vectorstock.com/i/1000v/51/87/student-avatar-user-profile-icon-vector-47025187.jpg",
                          ),
                        ),
                        SizedBox(height: 12),

                        Text(
                          vm.name.isNotEmpty ? vm.name : "Guest",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 20),
                        Divider(),

                        infoTile(Icons.person, "Name", vm.name),
                        infoTile(Icons.phone, "Phone", vm.phone),
                        infoTile(Icons.email, "Email", vm.email),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditProfilePage()),
                        );
                        context.read<ProfileVM>().loadUser();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? "Not set" : value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
