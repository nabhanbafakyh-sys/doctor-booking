import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/role/role.dart';

Widget buildRoleCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String role,
}) {
  final roleVM = context.watch<RoleViewModel>();
  final isSelected = roleVM.selectedRole == role;

  return GestureDetector(
    onTap: () {
      context.read<RoleViewModel>().selectRole(role);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.person, color: Colors.blue),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
              ],
            ),
          ),
          Radio<String>(
            value: role,
            onChanged: (value) {
              if (value != null) {
                context.read<RoleViewModel>().selectRole(value);
              }
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    ),
  );
}
