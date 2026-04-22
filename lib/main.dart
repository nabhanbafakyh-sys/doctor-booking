import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';
import 'package:room_rental/view_model/admin/doctor_addVM.dart';
import 'package:room_rental/view_model/auth/auth.dart';
import 'package:room_rental/view_model/user/appoinment_VM.dart';
import 'package:room_rental/view_model/user/profile.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';
import 'package:room_rental/view_model/user/booking_doctor.dart';
import 'package:room_rental/view_model/admin/admin_bottom_bar.dart';
import 'package:room_rental/view_model/role.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleViewModel()),
        ChangeNotifierProvider(create: (_) => AdminBottomBarvm()),
        ChangeNotifierProvider(create: (_) => userbotomVM()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()..fetchDoctors()),
        ChangeNotifierProvider(create: (_) => BookingVM()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => profileVM()),
        ChangeNotifierProvider(create: (_) => DoctorViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Scaffold(body: Center(child: CircularProgressIndicator()));
        //     }

        //     if (snapshot.hasData) {
        //       return UserBottomNav();
        //     }

        //     return Loginscren();
        //   },
        // ),
        home: RoleSelectionScreen(),
      ),
    );
  }
}
