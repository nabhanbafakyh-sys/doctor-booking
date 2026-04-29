import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/appoinments/wigets/appoinment_card.dart';
import 'package:room_rental/view/admin/appoinments/wigets/status_card.dart';
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
              title: Text(
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
}
