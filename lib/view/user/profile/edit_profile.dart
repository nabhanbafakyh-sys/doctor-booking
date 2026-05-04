import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/user/profile.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileVM>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: vm.nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: vm.phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: vm.emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      await vm.updateProfile();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
              child: vm.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
