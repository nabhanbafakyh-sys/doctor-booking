import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/sign_in/signin_page.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';
import 'package:room_rental/widgets/textform_feild.dart';

class Loginscren extends StatelessWidget {
  Loginscren({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  colors: [Colors.teal, Colors.transparent],
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
                      'Access your health dashboard',
                      textAlign: TextAlign.center,
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
                          if (user == null) throw Exception("User not found");
                          final db = FirebaseFirestore.instance;
                          final userRef = db.collection('users').doc(user.uid);
                          final userDoc = await userRef.get();
                          if (!userDoc.exists) {
                            debugPrint(" User doc missing → creating...");
                            await userRef.set({
                              'email': user.email,
                              'role': 'patient',
                              'clinicId': null,
                              'createdAt': Timestamp.now(),
                            });
                            throw Exception(
                              "User profile created. Please login again.",
                            );
                          }
                          final data = userDoc.data()!;
                          final role = data['role'];
                          final clinicId = data['clinicId'];
                          debugPrint("Role: $role");
                          debugPrint("ClinicId: $clinicId");
                          if (clinicId == null) {
                            throw Exception("No clinic assigned");
                          }
                          if (!context.mounted) return;
                          context.read<ClinicProvider>().setClinic(clinicId);
                          if (role == "admin") {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminBottomBar(),
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
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('OR'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SigninPage()),
                            );
                          },
                          child: Text(
                            'Create account',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
