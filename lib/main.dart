import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view_model/admin/admin_home_viewmodel.dart';
import 'package:room_rental/view_model/admin/admin_profile.dart';
import 'package:room_rental/view_model/admin/appoinment_fetch.dart';
import 'package:room_rental/view_model/admin/doctor_addVM.dart';
import 'package:room_rental/view_model/auth/auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';
import 'package:room_rental/view_model/user/appoinment_vm.dart';
import 'package:room_rental/view_model/user/homeviewmodel.dart';
import 'package:room_rental/view_model/user/mydoctors.dart';
import 'package:room_rental/view_model/user/profile.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';
import 'package:room_rental/view_model/user/booking_doctor.dart';
import 'package:room_rental/view_model/admin/admin_bottom_bar.dart';
import 'package:room_rental/view_model/role/role.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoleViewModel()),
        ChangeNotifierProvider(create: (_) => AdminBottomBarvm()),
        ChangeNotifierProvider(create: (_) => UserBottomBarvm()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ClinicProvider()..loadClinic()),
        ChangeNotifierProxyProvider<ClinicProvider, AdminHomeViewModel>(
          create: (context) =>
              AdminHomeViewModel(context.read<ClinicProvider>()),
          update: (_, clinic, __) => AdminHomeViewModel(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, DoctorViewModel>(
          create: (context) => DoctorViewModel(context.read<ClinicProvider>()),
          update: (_, clinic, __) => DoctorViewModel(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, AdminDashboardViewModel>(
          create: (context) =>
              AdminDashboardViewModel(context.read<ClinicProvider>()),
          update: (_, clinic, __) => AdminDashboardViewModel(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, AdminProfileVm>(
          create: (context) => AdminProfileVm(context.read<ClinicProvider>()),
          update: (_, clinic, __) => AdminProfileVm(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, AppointmentViewModel>(
          create: (context) =>
              AppointmentViewModel(context.read<ClinicProvider>()),
          update: (_, clinic, __) => AppointmentViewModel(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, BookingVM>(
          create: (context) => BookingVM(context.read<ClinicProvider>()),
          update: (_, clinic, __) => BookingVM(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, UserHomeViewModel>(
          create: (context) =>
              UserHomeViewModel(context.read<ClinicProvider>()),
          update: (_, clinic, __) => UserHomeViewModel(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, MyDoctorsViewModel>(
          create: (context) =>
              MyDoctorsViewModel(context.read<ClinicProvider>()),
          update: (_, clinic, __) => MyDoctorsViewModel(clinic),
        ),
        ChangeNotifierProxyProvider<ClinicProvider, ProfileVM>(
          create: (context) => ProfileVM(context.read<ClinicProvider>()),
          update: (_, clinic, __) => ProfileVM(clinic),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RoleSelectionScreen(),
      ),
    );
  }
}
