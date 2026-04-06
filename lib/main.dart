import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/role/role.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/bottom_nav.dart';
import 'package:room_rental/view_model/role.dart';

void main(List<String> args) {
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RoleSelectionScreen(),
      ),
    );
  }
}
