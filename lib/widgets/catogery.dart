import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryItem extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final bool selected;
  final VoidCallback ontap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.ontap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.teal.shade400 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 25,
              color: selected ? Colors.white : Colors.teal.shade400,
            ),
            SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
