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
        /// 🔄 Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// ❌ Not logged in
        if (!snapshot.hasData) {
          return Loginscren();
        }

        /// ✅ Logged in → load clinic + role
        return FutureBuilder(
          future: _handleUser(context),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final result = snap.data as String?;

            /// 🏥 Admin without clinic
            if (result == "create_clinic") {
              return const CreateClinicScreen();
            }

            /// 👨‍⚕️ Admin
            if (result == "admin") {
              return const AdminBottomBar();
            }

            /// 👤 User
            return const UserBottomNav();
          },
        );
      },
    );
  }

  /// 🔥 Main logic
  Future<String?> _handleUser(BuildContext context) async {
    final auth = context.read<AuthViewModel>();
    final clinicVM = context.read<ClinicProvider>();

    /// 1. Load clinic
    await clinicVM.loadClinic();

    final clinicId = clinicVM.clinicId;

    /// 2. Check if admin has clinic
    final hasClinic = await auth.hasClinic();

    if (!hasClinic) {
      return "create_clinic";
    }

    if (clinicId == null) {
      return null;
    }

    /// 3. Attach user (if needed)
    await auth.attachUserToClinic(clinicId);

    /// 4. Get role
    final role = await auth.getRole(clinicId);

    return role;
  }
}
