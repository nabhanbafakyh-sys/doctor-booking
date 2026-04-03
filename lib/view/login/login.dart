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
import 'package:room_rental/core/themes/app_colors.dart';
import 'package:room_rental/view/admin/admin_home.dart';
import 'package:room_rental/view/user/home/user_home.dart';
import 'package:room_rental/view_model/role.dart';
import 'package:room_rental/widgets/textform_feild.dart';

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
            Text(
              roleVM.selectedRole == 'admin' ? "Admin login" : 'Patient login',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 250,
              width: 390,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(25),
                      child: Image.network(
                        'https://t4.ftcdn.net/jpg/02/60/04/09/360_F_260040900_oO6YW1sHTnKxby4GcjCvtypUCWjnQRg5.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(height: 230, color: Colors.white70),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Acees your personalized health\n dashboard and health records. ',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: customtextfield(
                hintText: 'Email',
                controller: email,
                Label: "Email Id",
                prefixicon: Icons.mail_outline_rounded,
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: customtextfield(
                hintText: 'password',
                controller: password,
                Label: "Password",
                prefixicon: Icons.lock_outline_sharp,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (roleVM.selectedRole == "admin") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => AdminHome()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => UserHome()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                minimumSize: Size(200, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.surfaceLow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
