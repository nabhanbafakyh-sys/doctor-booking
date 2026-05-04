import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view_model/auth/auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class CreateClinicScreen extends StatefulWidget {
  const CreateClinicScreen({super.key});

  @override
  State<CreateClinicScreen> createState() => _CreateClinicScreenState();
}

class _CreateClinicScreenState extends State<CreateClinicScreen> {
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          /// 🔵 HEADER
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A8DFF), Color(0xFF9FB3FF)],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// 🔥 TITLE
                  const Text(
                    "Create Clinic",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 CARD
                  Container(
                    width: double.infinity,
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
                        /// INPUT
                        TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.local_hospital_outlined,
                            ),
                            labelText: "Clinic Name",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// BUTTON
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
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                                    if (nameCtrl.text.isEmpty) {
                                      showMsg("Enter clinic name");
                                      return;
                                    }

                                    final id = await context
                                        .read<AuthViewModel>()
                                        .createClinic(nameCtrl.text.trim());

                                    if (id == null) {
                                      showMsg("Failed");
                                      return;
                                    }

                                    await context
                                        .read<ClinicProvider>()
                                        .loadClinic();

                                    if (!context.mounted) return;

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const AdminBottomBar(),
                                      ),
                                    );
                                  },
                            child: vm.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "Create Clinic",
                                    style: TextStyle(fontSize: 16),
                                  ),
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

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
