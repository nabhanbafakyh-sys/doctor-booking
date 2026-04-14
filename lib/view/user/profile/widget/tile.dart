import 'package:flutter/material.dart';

Widget buildTile(
  BuildContext context,
  IconData icon,
  String title, {
  bool isLogout = false,
  VoidCallback? onTap,
}) {
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
      onTap: onTap,
    ),
  );
}
