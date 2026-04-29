import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminAppointmentHistory extends StatelessWidget {
  const AdminAppointmentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Appointment History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;

            try {
              final parsed = DateTime.parse(data['date']);
              final apptDate = DateTime(parsed.year, parsed.month, parsed.day);

              return apptDate.isBefore(today);
            } catch (e) {
              return false;
            }
          }).toList();

          if (docs.isEmpty) {
            return Center(child: Text("No past appointments"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              DateTime parsedDate = DateTime.parse(data['date']);
              String date = DateFormat('MMM dd, yyyy').format(parsedDate);

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data['doctorName'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Patient: ${data['userName'] ?? ''}"),
                      Text("Date: $date"),
                      Text("Time: ${data['time']}"),
                      Text("Status: ${data['status']}"),
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
