import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/admin/createclinic/create_clinic.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/role/role.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final phoneController = TextEditingController();

  List<Map<String, dynamic>> clinics = [];
  String? selectedClinicId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadClinics();
    });
  }

  Future<void> loadClinics() async {
    final snap = await FirebaseFirestore.instance.collection('clinics').get();

    clinics = snap.docs.map((e) {
      return {'id': e.id, 'name': e['name']};
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleViewModel>().selectedRole;

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 90),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(blurRadius: 10, color: Colors.black12),
                      ],
                    ),
                    child: Column(
                      children: [
                        _field(username, "Username", Icons.person),
                        _gap(),
                        _field(email, "Email", Icons.email),
                        _gap(),
                        _field(
                          password,
                          "Password",
                          Icons.lock,
                          isPassword: true,
                        ),
                        _gap(),
                        _field(phoneController, "Phone", Icons.phone),
                        _gap(),

                        if (role == "patient")
                          GestureDetector(
                            onTap: () => _showClinicBottomSheet(),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.local_hospital,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      selectedClinicId == null
                                          ? "Select Clinic"
                                          : clinics.firstWhere(
                                              (c) =>
                                                  c['id'] == selectedClinicId,
                                            )['name'],
                                      style: TextStyle(
                                        color: selectedClinicId == null
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6A8DFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (role == null) {
                                      showMsg("Select role");
                                      return;
                                    }

                                    if (username.text.isEmpty ||
                                        email.text.isEmpty ||
                                        password.text.isEmpty) {
                                      showMsg("Fill all fields");
                                      return;
                                    }

                                    if (role == "patient" &&
                                        selectedClinicId == null) {
                                      showMsg("Select clinic");
                                      return;
                                    }

                                    try {
                                      setState(() => isLoading = true);

                                      final cred = await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                            email: email.text.trim(),
                                            password: password.text.trim(),
                                          );

                                      final user = cred.user;

                                      if (role == "admin") {
                                        final existing = await FirebaseFirestore
                                            .instance
                                            .collection('clinics')
                                            .where(
                                              'adminId',
                                              isEqualTo: user!.uid,
                                            )
                                            .get();

                                        if (existing.docs.isNotEmpty) {
                                          final clinicId =
                                              existing.docs.first.id;

                                          /// 🔥 SAVE GLOBAL ADMIN
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user.uid)
                                              .set({
                                                'name': username.text.trim(),
                                                'email': user.email,
                                                'role': 'admin',
                                                'clinicId': clinicId,
                                              });

                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const AdminBottomBar(),
                                            ),
                                          );
                                        } else {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CreateClinicScreen(),
                                            ),
                                          );
                                        }
                                      }
                                      /// USER
                                      /// USER (PATIENT)
                                      else {
                                        final uid = user!.uid;

                                        /// ✅ SAVE IN GLOBAL USERS
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .set({
                                              'name': username.text.trim(),
                                              'email': user.email,
                                              'phone': phoneController.text
                                                  .trim(),
                                              'role': 'patient',
                                              'clinicId': selectedClinicId,
                                              'createdAt': Timestamp.now(),
                                            });

                                        /// ✅ SAVE IN CLINIC USERS
                                        await FirebaseFirestore.instance
                                            .collection('clinics')
                                            .doc(selectedClinicId)
                                            .collection('users')
                                            .doc(uid)
                                            .set({
                                              'name': username.text.trim(),
                                              'email': user.email,
                                              'phone': phoneController.text
                                                  .trim(),
                                              'role': 'patient',
                                              'clinicId': selectedClinicId,
                                            });

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const UserBottomNav(),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      showMsg("Signup failed: $e");
                                    } finally {
                                      if (mounted) {
                                        setState(() => isLoading = false);
                                      }
                                    }
                                  },
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("Sign Up"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 15);

  void _showClinicBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: clinics.map((c) {
            return ListTile(
              title: Text(c['name']),
              onTap: () {
                setState(() {
                  selectedClinicId = c['id'];
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
