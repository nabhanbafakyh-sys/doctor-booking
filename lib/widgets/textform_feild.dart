import 'package:flutter/material.dart';

class Customtextfield extends StatefulWidget {
  final String hintText;
  final String label;
  final IconData prefixicon;
  final TextEditingController controller;
  const Customtextfield({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixicon,
    required this.controller,
  });

  @override
  State<Customtextfield> createState() => CustomtextfieldState();
}

class CustomtextfieldState extends State<Customtextfield> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.prefixicon),
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
