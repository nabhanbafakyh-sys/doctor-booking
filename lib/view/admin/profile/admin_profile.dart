import 'package:flutter/material.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/widgets/sectioncard.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          buildSectionCard(
            children: [
              buildTile(
                Icons.logout,
                'Log out',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoleSelectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
