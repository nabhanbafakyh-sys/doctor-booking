import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/doctors/doctors_list.dart';
import 'package:room_rental/view/admin/home/admin_home.dart';
import 'package:room_rental/view/admin/profile/admin_profile.dart';
import 'package:room_rental/view/admin/schedule/schedule_screen.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';

class AdminBottomBar extends StatelessWidget {
  const AdminBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BottomBarviewmodel>();

    final pages = [
      AdminHome(),
      DoctorsList(),
      ScheduleScreen(),
      AdminProfile(),
    ];

    return Scaffold(
      body: pages[vm.selectedpage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.selectedpage,
        onTap: vm.changepage,
        selectedItemColor: const Color(0xFF1E2A78),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Doctors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Schedule",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
