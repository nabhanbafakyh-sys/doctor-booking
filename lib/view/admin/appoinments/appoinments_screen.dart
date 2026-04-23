import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/admin/appoinment_fetch.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminDashboardViewModel(),

      child: Consumer<AdminDashboardViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                "Appointment Oversight",
                style: TextStyle(color: Colors.black),
              ),
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Search...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Bookings Today",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${vm.totalToday}",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      statCard("${vm.pending}", "Pending", Colors.orange),
                      SizedBox(width: 10),
                      statCard("${vm.cancelled}", "Cancelled", Colors.red),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vm.appointments.length,
                    itemBuilder: (context, index) {
                      final a = vm.appointments[index];

                      bool confirmed = a['status'] == 'confirmed';

                      return appointmentCard(a, confirmed, context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 🔹 SMALL CARD
  Widget statCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

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
          /// NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                a['userName'] ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                (a['status'] ?? '').toUpperCase(),
                style: TextStyle(
                  color: confirmed ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text("Doctor: ${a['doctorName']}"),
          Text("Time: ${a['time']}"),
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
}
