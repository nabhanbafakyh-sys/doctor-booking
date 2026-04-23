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
                  /// 🔍 SEARCH
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: "Search...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 BIG CARD
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
                        const Text(
                          "Total Bookings Today",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${vm.totalToday}",
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 🔹 SMALL STATS
                  Row(
                    children: [
                      statCard("${vm.pending}", "Pending", Colors.orange),
                      const SizedBox(width: 10),
                      statCard("${vm.cancelled}", "Cancelled", Colors.red),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 LIST
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
          borderRadius: BorderRadius.circular(16),
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

  /// 🔥 APPOINTMENT CARD
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
        border: Border.all(
          color: confirmed ? Colors.green : Colors.grey.shade300,
        ),
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
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                (a['status'] ?? '').toUpperCase(),
                style: TextStyle(
                  color: confirmed ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text("Doctor: ${a['doctorName']}"),
          Text("Time: ${a['time']}"),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => vm.cancel(a['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade200,
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => vm.approve(a['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Approve"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
