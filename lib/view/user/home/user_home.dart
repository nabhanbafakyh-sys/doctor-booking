import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:room_rental/view_model/admin_home_VM.dart';
import 'package:room_rental/widgets/catogery.dart';
import 'package:room_rental/widgets/doctor_card.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeViewModel>().fetchDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.person_2_outlined),
        ),
        title: const Text('Vitality'),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none_outlined),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, User 👋',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              Text(
                'Find your doctor',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_outlined),
                    hintText: 'Search your doctor, specialties',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Departments",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryItem(
                      icon: FontAwesomeIcons.hospital,
                      label: 'General',
                    ),
                    CategoryItem(
                      icon: FontAwesomeIcons.heartPulse,
                      label: 'Cardio',
                    ),
                    CategoryItem(icon: FontAwesomeIcons.brain, label: 'Neuro'),
                    CategoryItem(icon: FontAwesomeIcons.tooth, label: 'Dental'),
                    CategoryItem(
                      icon: FontAwesomeIcons.faceSmile,
                      label: 'Pediatrics',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Our Doctors,",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Expanded(
                child: vm.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : vm.doctors.isEmpty
                    ? Center(child: Text("No doctors found"))
                    : ListView.builder(
                        itemCount: vm.doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = vm.doctors[index];
                          return DoctorCard(
                            name: doctor['name'] ?? '',
                            specialty: doctor['specialization'] ?? '',
                            rating: "4.5",
                            imageUrl: '',
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
