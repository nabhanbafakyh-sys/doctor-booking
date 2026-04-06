import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/user/appoinment/user_appoinments.dart';
import 'package:room_rental/view/user/home/user_home.dart';
import 'package:room_rental/view/user/profile/user_profile.dart';
import 'package:room_rental/view_model/bottom_nav.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navVM = context.watch<BottomNavViewModel>();

    final screens = [UserHome(), UserProfile(), UserAppoinments()];

    return Scaffold(
      body: screens[navVM.selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navVM.selectedIndex,
        onTap: navVM.changeIndex,
        selectedItemColor: const Color(0xFF1E2A78),
        unselectedItemColor: Colors.grey,
        items: const [
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
