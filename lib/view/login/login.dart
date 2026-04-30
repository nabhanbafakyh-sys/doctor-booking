import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/sign_in/signin_page.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/widgets/textform_feild.dart';

class Loginscren extends StatelessWidget {
  Loginscren({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final roleVM = context.watch<RoleViewModel>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A8DFF), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Image.network(
                      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                      height: 110,
                    ),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Access your personalized health\n dashboard and health records.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 40),
                    Customtextfield(
                      hintText: 'Email',
                      controller: email,
                      label: "Email Id",
                      prefixicon: Icons.mail_outline_rounded,
                    ),
                    SizedBox(height: 15),
                    Customtextfield(
                      hintText: 'Password',
                      controller: password,
                      label: "Password",
                      prefixicon: Icons.lock_outline_sharp,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final cred = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim(),
                              );
                          final user = cred.user;
                          final doc = await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user!.uid)
                              .get();

                          if (!doc.exists) {
                            throw Exception("User data not found");
                          }
                          final role = doc['role'];
                          debugPrint("Logged in as: $role");
                          if (!context.mounted) return;
                          if (role == "admin") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminBottomBar(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserBottomNav(),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint("Login error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login failed: $e")),
                          );
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SigninPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
