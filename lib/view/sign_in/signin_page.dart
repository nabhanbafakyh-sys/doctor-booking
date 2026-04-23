import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/core/themes/app_colors.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/role/role.dart';
import 'package:room_rental/widgets/textform_feild.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final roleVM = context.watch<RoleViewModel>();
    return Scaffold(
      backgroundColor: AppColors.surface,
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
                    SizedBox(height: 100),
                    Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Sign up and improve your health today.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 40),
                    Customtextfield(
                      label: 'Username',
                      hintText: 'username',
                      prefixicon: Icons.person,
                      controller: username,
                    ),
                    SizedBox(height: 15),
                    Customtextfield(
                      hintText: 'Email',
                      controller: email,
                      label: "Email Id",
                      prefixicon: Icons.mail_outline_rounded,
                    ),

                    SizedBox(height: 15),
                    Customtextfield(
                      label: "Password",
                      hintText: 'Enter password',
                      prefixicon: Icons.lock_outline_sharp,
                      controller: password,
                    ),
                    SizedBox(height: 15),
                    Customtextfield(
                      label: 'Phone number',
                      hintText: 'number',
                      prefixicon: Icons.call,
                      controller: phoneController,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final role = context
                              .read<RoleViewModel>()
                              .selectedRole;
                          if (role == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a role"),
                              ),
                            );
                            return;
                          }
                          final cred = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim(),
                              );

                          final user = cred.user;
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(user!.uid)
                              .set({
                                'name': username.text.trim(),
                                'email': user.email,
                                'phone': phoneController.text.trim(),
                                'role': role,
                                'image': "",
                                'createdAt': FieldValue.serverTimestamp(),
                              });
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
                                builder: (_) => const UserBottomNav(),
                              ),
                            );
                          }
                        } catch (e) {
                          debugPrint("Signup error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Signup failed: $e")),
                          );
                        }
                      },
                      child: const Text("signin "),
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
                    Text(
                      'Sign up with',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Image.asset('assets/google.png'),
                              Text(
                                '  Google',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Image.asset('assets/facebook.png'),
                              Text(
                                'facebook',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
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
