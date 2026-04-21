import 'package:flutter/material.dart';

Widget buildSectionCard({required List<Widget> children}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    ),
  );
}

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
