import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/user/profile.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final vm = context.read<ProfileVM>();

    nameController.text = vm.name;
    phoneController.text = vm.phone;
    emailController.text = vm.email;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ProfileVM>();

    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await vm.updateProfile(
                  newName: nameController.text.trim(),
                  newPhone: phoneController.text.trim(),
                  newEmail: emailController.text.trim(),
                );

                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
