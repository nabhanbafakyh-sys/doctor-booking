import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/login/login.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view/user/home/user_home.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';
import 'package:room_rental/view_model/auth/sign.dart';
import 'package:room_rental/view_model/user/appoinment_VM.dart';
import 'package:room_rental/view_model/user/profile.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';
import 'package:room_rental/view_model/user/booking_doctor.dart';
import 'package:room_rental/view_model/admin/admin_bottom_bar..dart';
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
        ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
        ChangeNotifierProvider(create: (_) => BottomBarviewmodel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => BookingVM()),
        ChangeNotifierProvider(create: (_) => AppointmentViewModel()),
        ChangeNotifierProvider(create: (_) => AuthVM()),
        ChangeNotifierProvider(create: (_) => profileVM()),
      ],
      child: MaterialApp(
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (snapshot.hasData) {
              return UserBottomNav();
            }

            return Loginscren();
          },
        ),
      ),
    );
  }
}
