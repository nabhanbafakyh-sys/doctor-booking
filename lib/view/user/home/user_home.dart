import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:room_rental/widgets/catogery.dart';
import 'package:room_rental/widgets/doctor_card.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.person_2_outlined),
        ),
        title: const Text('Vitality'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hello, User 👋',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  Text(
                    'Find your doctor',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_outlined),
                    hintText: 'Search your doctor, specialties',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Row(
                  children: [
                    Text(
                      "Department's",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const CategoryItem(
                      icon: FontAwesomeIcons.hospital,
                      label: 'General',
                    ),

                    CategoryItem(
                      icon: FontAwesomeIcons.heartPulse,
                      label: 'Cardio',
                    ),
                    CategoryItem(icon: FontAwesomeIcons.brain, label: 'Nureo'),
                    CategoryItem(icon: FontAwesomeIcons.tooth, label: 'Dental'),
                    CategoryItem(
                      icon: FontAwesomeIcons.faceSmile,
                      label: 'Padiatrics',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text("Available Doctor's")],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    DoctorCard(
                      name: "Dr. Sarah Mitchell",
                      specialty: "General Physician",
                      rating: "4.8",
                    ),
                    DoctorCard(
                      name: "Dr. James Wilson",
                      specialty: "Cardiologist",
                      rating: "4.5",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
