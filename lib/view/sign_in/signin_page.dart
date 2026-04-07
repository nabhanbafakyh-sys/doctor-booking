import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/core/themes/app_colors.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/role.dart';
import 'package:room_rental/widgets/textform_feild.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final roleVM = context.watch<RoleViewModel>();
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
                    SizedBox(height: 15),
                    Customtextfield(
                      label: "Confirm password",
                      hintText: 'Re Enter password',
                      prefixicon: Icons.lock_outline_sharp,
                      controller: password,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (roleVM.selectedRole == "admin") {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => AdminBottomBar()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => UserBottomNav()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "create account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.surfaceLow,
                        ),
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
