import 'package:flutter/material.dart';
import 'package:room_rental/view/doctor_details/doctor_details.dart';

class AdminDoctorCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String hospital;
  final double rating;
  final String imageUrl;
  final String docId;

  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const AdminDoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.rating,
    required this.imageUrl,
    required this.docId,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          /// 🔹 TOP SECTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 40),
              ),

              const SizedBox(width: 12),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        specialization.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      hospital,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              /// RIGHT SIDE (EDIT + RATING)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// ✏️ EDIT
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.teal),
                  ),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 BUTTONS
          Row(
            children: [
              /// DELETE
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// DETAILS
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorDetailsPage(
                          data: {
                            'name': name,
                            'specialization': specialization,
                            'hospital': hospital,
                            'rating': rating,
                            'image': imageUrl,
                            'bio': "",
                          },

                          docId: docId,
                          isAdmin: true,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list_alt),
                  label: const Text("Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
