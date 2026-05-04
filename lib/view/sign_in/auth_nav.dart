import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/admin/createclinic/create_clinic.dart';
import 'package:room_rental/view/login/login.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/auth/auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();

    return StreamBuilder(
      stream: auth.authState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData) {
          return Loginscren();
        }
        return FutureBuilder(
          future: _handleUser(context),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            final result = snap.data;
            if (result == "create_clinic") {
              return CreateClinicScreen();
            }
            if (result == "admin") {
              return AdminBottomBar();
            }
            return UserBottomNav();
          },
        );
      },
    );
  }

  Future<String?> _handleUser(BuildContext context) async {
    final auth = context.read<AuthViewModel>();
    final clinicVM = context.read<ClinicProvider>();
    await clinicVM.loadClinic();
    final clinicId = clinicVM.clinicId;
    final hasClinic = await auth.hasClinic();

    if (!hasClinic) {
      return "create_clinic";
    }
    if (clinicId == null) {
      return null;
    }
    await auth.attachUserToClinic(clinicId);
    final role = await auth.getRole(clinicId);
    return role;
  }
}
