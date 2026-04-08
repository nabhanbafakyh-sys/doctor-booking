import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view_model/admin_home_viewmodel.dart';
import 'package:room_rental/view_model/appoinment_VM.dart';
import 'package:room_rental/view_model/user_bottom_bar.dart';
import 'package:room_rental/view_model/booking_doctor.dart';
import 'package:room_rental/view_model/admin_bottom_bar..dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RoleSelectionScreen(),
      ),
    );
  }
}
