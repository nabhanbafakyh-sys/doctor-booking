import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view/admin/createclinic/widget/field.dart';
import 'package:room_rental/view_model/auth/auth.dart';
import 'package:room_rental/view_model/clinic/clinic_vm.dart';

class CreateClinicScreen extends StatefulWidget {
  const CreateClinicScreen({super.key});

  @override
  State<CreateClinicScreen> createState() => _CreateClinicScreenState();
}

class _CreateClinicScreenState extends State<CreateClinicScreen> {
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final adminNameCtrl = TextEditingController();
  final adminPhoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

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
                  SizedBox(height: 40),

                  Text(
                    "Create Clinic",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(blurRadius: 10, color: Colors.black12),
                      ],
                    ),
                    child: Column(
                      children: [
                        field(
                          adminNameCtrl,
                          "Your Name",
                          Icons.person_outlined,
                        ),
                        SizedBox(height: 15),
                        field(
                          adminPhoneCtrl,
                          "Your Phone",
                          Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 15),
                        field(
                          nameCtrl,
                          "Clinic Name",
                          Icons.local_hospital_outlined,
                        ),
                        SizedBox(height: 15),
                        field(
                          addressCtrl,
                          "Address",
                          Icons.location_on_outlined,
                        ),
                        SizedBox(height: 15),
                        field(
                          phoneCtrl,
                          "Phone",
                          Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6A8DFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                                    if (nameCtrl.text.isEmpty ||
                                        addressCtrl.text.isEmpty ||
                                        phoneCtrl.text.isEmpty ||
                                        addressCtrl.text.isEmpty ||
                                        phoneCtrl.text.isEmpty) {
                                      showMsg("Fill all fields");
                                      return;
                                    }

                                    final id = await context
                                        .read<AuthViewModel>()
                                        .createClinicWithDetails(
                                          name: nameCtrl.text.trim(),
                                          address: addressCtrl.text.trim(),
                                          phone: phoneCtrl.text.trim(),
                                          adminName: adminNameCtrl.text.trim(),
                                          adminPhone: adminPhoneCtrl.text
                                              .trim(),
                                        );

                                    if (id == null) {
                                      showMsg("Failed to create clinic");
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
