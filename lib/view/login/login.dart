// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:room_rental/view/user/home/user_home.dart';
// import 'package:room_rental/view_model/role.dart';
// import '../admin/admin_home.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final roleVM = context.watch<RoleViewModel>();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 40),

//             Text(
//               roleVM.selectedRole == "admin" ? "Admin Login" : "User Login",
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 30),

//             // 📧 Email
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 hintText: "Email",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // 🔒 Password
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: "Password",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             // 🔘 LOGIN BUTTON
//             ElevatedButton(
//               onPressed: () {
//                 if (roleVM.selectedRole == "admin") {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const AdminHome()),
//                   );
//                 } else {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (_) => const UserHome()),
//                   );
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 55),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: const Text("Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/role.dart';

class Loginscren extends StatelessWidget {
  Loginscren({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final roleVM = context.watch<RoleViewModel>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 90),
            Text(
              roleVM.selectedRole == 'admin' ? "Admin login" : 'Patient login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
