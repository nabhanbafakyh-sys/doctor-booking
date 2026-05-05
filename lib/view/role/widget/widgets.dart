import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/role/role.dart';

Widget buildRoleCard(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String role,
  required IconData icon,
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
        color: isSelected ? Colors.teal.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.teal.shade50 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          if (isSelected) const BoxShadow(color: Colors.teal, blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.teal),
          ),

          SizedBox(width: 16),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          /// SINGLE RADIO (CORRECT)
          Radio<String>(
            value: role,
            groupValue: roleVM.selectedRole,
            activeColor: Colors.teal,
            onChanged: (value) {
              if (value != null) {
                context.read<RoleViewModel>().selectRole(value);
              }
            },
          ),
        ],
      ),
    ),
  );
}
