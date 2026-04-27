import 'package:flutter/material.dart';
import 'package:room_rental/model/doctor.dart';
import 'package:room_rental/view/doctor_details/doctor_details.dart';
import 'package:room_rental/view/user/booking/boking_page.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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
                        doctor.specialization.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      doctor.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      doctor.hospital,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.orange, size: 20),
                  SizedBox(width: 4),
                  Text(
                    doctor.rating.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          doctorid: doctor.id,
                          doctorName: doctor.name,
                          hospital: doctor.hospital,
                          specialty: doctor.specialization,
                          imageUrl: doctor.image,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
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
                          doctor: {
                            'name': doctor.name,
                            'specialization': doctor.specialization,
                            'hospital': doctor.hospital,
                            'image': doctor.image,
                            'rating': doctor.rating,
                          },
                          docId: doctor.id,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.info_outline),
                  label: Text("Details"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2, // optional shadow
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
