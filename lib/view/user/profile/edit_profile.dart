import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/user/profile.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<Profilevm>();

    // preload values (only once per build is fine here)
    nameController.text = vm.name;
    phoneController.text = vm.phone;
    emailController.text = vm.email;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Profile Avatar
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                "https://cdn.vectorstock.com/i/1000v/51/87/student-avatar-user-profile-icon-vector-47025187.jpg",
              ),
            ),

            const SizedBox(height: 25),

            // 🔹 Card Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  buildTextField(
                    controller: nameController,
                    label: "Name",
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 15),

                  buildTextField(
                    controller: phoneController,
                    label: "Phone",
                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 15),

                  buildTextField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 🔹 Update Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await vm.updateProfile(
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    email: emailController.text.trim(),
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  "Update Profile",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Reusable TextField
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
