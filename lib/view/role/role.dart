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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset("assets/role.png", height: 220),
              SizedBox(height: 20),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text("Choose your role", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 30),

              buildRoleCard(
                context,
                title: "I'm a Patient",
                subtitle: "Book appointments with doctors",
                role: "patient",
                icon: Icons.person_outline,
              ),

              buildRoleCard(
                context,
                title: "I'm an Admin",
                subtitle: "Manage doctors and bookings",
                role: "admin",
                icon: Icons.admin_panel_settings_outlined,
              ),

              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: roleVM.selectedRole == null
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Loginscren()),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Continue →",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
