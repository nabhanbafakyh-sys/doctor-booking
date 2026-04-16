import 'package:flutter/material.dart';

Widget buildTile(IconData icon, String title, {VoidCallback? onTap}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.teal.withValues(alpha: 0.1),
      child: Icon(icon, color: Colors.teal),
    ),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}
