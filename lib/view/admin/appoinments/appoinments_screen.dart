import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAppointmentsPage extends StatelessWidget {
  const AdminAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointments")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(child: Text("No appointments"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              final date = DateTime.parse(data['date']);

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text(data['doctorName'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Specialization: ${data['specialization'] ?? ''}"),
                      Text("Patient: ${data['userName'] ?? ''}"),
                      Text("Date: ${date.day}-${date.month}-${date.year}"),
                      Text("Time: ${data['time'] ?? ''}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
