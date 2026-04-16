import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/core/themes/app_colors.dart';
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
  TextEditingController username = TextEditingController();

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
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        // try {
                        //   await context.read<AuthVM>().registerUser(
                        //     username: username.text.trim(),
                        //     email: email.text.trim(),
                        //     password: password.text.trim(),
                        //   );
                        // } catch (e) {
                        //   ScaffoldMessenger.of(
                        //     context,
                        //   ).showSnackBar(SnackBar(content: Text(e.toString())));
                        // }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserBottomNav(),
                          ),
                        );
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
