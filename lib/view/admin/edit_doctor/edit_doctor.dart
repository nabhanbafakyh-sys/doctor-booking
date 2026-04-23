import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room_rental/view/admin/bottom/bottom_bar.dart';

class EditDoctorPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditDoctorPage({super.key, required this.docId, required this.data});

  @override
  State<EditDoctorPage> createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  late TextEditingController nameController;
  late TextEditingController specializationController;
  late TextEditingController hospitalController;
  late TextEditingController ratingController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.data['name']);
    specializationController = TextEditingController(
      text: widget.data['specialization'],
    );
    hospitalController = TextEditingController(text: widget.data['hospital']);
    ratingController = TextEditingController(
      text: widget.data['rating'].toString(),
    );
    bioController = TextEditingController(text: widget.data['bio']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 248, 248),

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
          "Edit Doctor",
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
                  child: Icon(Icons.person, size: 40),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            buildTextField(
              "Full Legal Name",
              Icons.person,
              controller: nameController,
            ),
            buildTextField(
              "Medical Specialty",
              Icons.medical_services,
              controller: specializationController,
            ),
            buildTextField(
              "Hospital",
              Icons.local_hospital,
              controller: hospitalController,
            ),
            buildTextField("Ratings", Icons.star, controller: ratingController),
            SizedBox(height: 20),
            buildTextField(
              "Professional Bio",
              Icons.description,
              controller: bioController,
              maxLines: 4,
            ),
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
                  await FirebaseFirestore.instance
                      .collection('Doctors')
                      .doc(widget.docId)
                      .update({
                        'name': nameController.text,
                        'specialization': specializationController.text,
                        'hospital': hospitalController.text,
                        'rating': double.tryParse(ratingController.text) ?? 0.0,
                        'bio': bioController.text,
                      });
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                icon: Icon(Icons.save),
                label: Text("Update Doctor", style: TextStyle(fontSize: 16)),
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
    required TextEditingController controller,
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
}
