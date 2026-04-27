import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/login/login.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/auth/auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();

    return StreamBuilder(
      stream: auth.authState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: auth.getRole(),
            builder: (context, roleSnap) {
              if (!roleSnap.hasData) {
                return const CircularProgressIndicator();
              }

              if (roleSnap.data == "admin") {
                return const AdminBottomBar();
              } else {
                return const UserBottomNav();
              }
            },
          );
        }

        return Loginscren();
      },
    );
  }
}
