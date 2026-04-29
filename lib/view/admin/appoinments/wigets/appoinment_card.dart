import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/admin/appoinment_fetch.dart';

Widget appointmentCard(
  Map<String, dynamic> a,
  bool confirmed,
  BuildContext context,
) {
  final vm = context.read<AdminDashboardViewModel>();

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Patient: ${a['userName'] ?? 'Unknown'}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              (a['status'] ?? '').toUpperCase(),
              style: TextStyle(color: confirmed ? Colors.green : Colors.orange),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text("Doctor: ${a['doctorName']}"),
        Text("Time: ${a['time']}"),
        Text("Date:${a['date']}"),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => vm.cancel(a['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade200,
                ),
                child: Text("Cancel"),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => vm.approve(a['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade400,
                ),
                child: Text("Approve"),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
