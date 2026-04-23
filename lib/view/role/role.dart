import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/login/login.dart';
import 'package:room_rental/view/role/widget/widgets.dart';
import 'package:room_rental/view_model/role/role.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final roleVM = context.watch<RoleViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 60),

                Image.asset("assets/role.png", height: 250),

                const SizedBox(height: 20),

                const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const Text("Choose your role"),

                const SizedBox(height: 30),

                RadioGroup<String>(
                  groupValue: roleVM.selectedRole,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<RoleViewModel>().selectRole(value);
                    }
                  },
                  child: Column(
                    children: [
                      buildRoleCard(
                        context,
                        title: "I'm a Patient",
                        subtitle: "Book appointments with doctors",
                        role: "patient",
                      ),
                      buildRoleCard(
                        context,
                        title: "I'm an Admin",
                        subtitle: "Manage doctors and bookings",
                        role: "admin",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40), // ✅ FIX

                ElevatedButton(
                  onPressed: roleVM.selectedRole == null
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginscren(),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Continue →"),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
