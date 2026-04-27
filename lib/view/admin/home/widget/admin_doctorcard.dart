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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(width: 12),
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
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      hospital,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.star, color: Colors.orange, size: 18),
              SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, color: Colors.red.shade300),
                  label: Text("Delete", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorDetailsPage(
                          docId: docId,
                          isAdmin: true,
                          doctor: {},
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.list_alt, color: Colors.white),
                  label: Text("Details", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade300,
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
