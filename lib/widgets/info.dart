import 'package:flutter/material.dart';

// date and time
Widget infoBox(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.teal.shade400),
        const SizedBox(width: 6),
        Text(text),
      ],
    ),
  );
}
