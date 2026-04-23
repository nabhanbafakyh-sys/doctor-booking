import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';
import 'package:room_rental/view_model/admin/doctor_addVM.dart';

class AddDoctorPage extends StatelessWidget {
  AddDoctorPage({super.key});
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController specializationcontroller =
      TextEditingController();
  final TextEditingController hospitalcontroller = TextEditingController();
  final TextEditingController ratingcontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminBottomBar()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Add New Doctor",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.grey[700]),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.teal.shade300,
                    child: Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Upload Professional Profile Photo",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            buildTextField(
              "Full Legal Name",
              Icons.person,
              controller: namecontroller,
            ),
            buildTextField(
              "Medical Specialty",
              Icons.medical_services,
              controller: specializationcontroller,
            ),
            buildTextField(
              "Hospital",
              Icons.local_hospital,
              controller: hospitalcontroller,
            ),
            buildTextField(
              "Ratings",
              Icons.rate_review,
              controller: ratingcontroller,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Consultation Hours",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                buildTimeCard("Mon - Wed", "08:00 - 14:00"),
                SizedBox(width: 10),
                buildTimeCard("Thu - Fri", "10:00 - 18:00"),
              ],
            ),
            SizedBox(height: 15),
            buildTextField("Professional Bio", Icons.description, maxLines: 4),
            SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  final vm = context.read<DoctorViewModel>();
                  await vm.addDoctor(
                    name: namecontroller.text,
                    specialization: specializationcontroller.text,
                    hospital: hospitalcontroller.text,
                    rating: ratingcontroller.text,
                    bio: '',
                  );
                  Navigator.pop(context);
                },
                icon: Icon(Icons.person_add),
                label: Text(
                  "Add Doctor to Registry",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    IconData icon, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildTimeCard(String day, String time) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(day, style: TextStyle(fontSize: 12)),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
