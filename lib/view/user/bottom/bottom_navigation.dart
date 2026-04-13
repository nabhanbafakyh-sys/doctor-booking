import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/user/appoinment/user_appoinments.dart';
import 'package:room_rental/view/user/home/user_home.dart';
import 'package:room_rental/view/user/profile/user_profile.dart';
import 'package:room_rental/view_model/admin_bottom_bar..dart';

class UserBottomNav extends StatelessWidget {
  const UserBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<BottomNavViewModel>();

    final screens = [UserHome(), UserAppointments(), UserProfile()];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: screens[navVM.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        currentIndex: navVM.selectedIndex,
        onTap: navVM.changeIndex,
        selectedItemColor: const Color(0xFF1E2A78),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
