import 'package:flutter/material.dart';
import 'package:room_rental/view/user/booking/boking_page.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final String rating;
  final String imageUrl;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
            child: imageUrl.isEmpty ? Icon(Icons.person) : null,
          ),
          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(specialty, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text("★ $rating"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(
                        doctorName: name,
                        imageUrl: imageUrl,
                        specialty: specialty,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Book now"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
