import 'package:flutter/material.dart';

class customtextfield extends StatelessWidget {
  final String hintText;
  final String Label;
  final IconData prefixicon;
  final TextEditingController controller;
  const customtextfield({
    super.key,
    required this.Label,
    required this.hintText,
    required this.prefixicon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(prefixicon),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        
      ],
    );
  }
}
