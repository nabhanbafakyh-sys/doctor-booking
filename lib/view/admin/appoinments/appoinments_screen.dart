import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/appoinments/wigets/appoinment_card.dart';
import 'package:room_rental/view/admin/appoinments/wigets/status_card.dart';
import 'package:room_rental/view_model/admin/appoinment_fetch.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Appointment Oversight",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search appointments...",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "Total Bookings Today",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${vm.totalToday}',
                    style: TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Row(
              children: [
                MiniStatCard(
                  label: 'Pending',
                  value: '${vm.pending}',
                  color: Colors.orange,
                  icon: Icons.hourglass_top_outlined,
                ),
                SizedBox(width: 12),
                MiniStatCard(
                  label: 'Cancelled',
                  value: '${vm.cancelled}',
                  color: Colors.red,
                  icon: Icons.cancel_outlined,
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Appointments (${vm.appointments.length})",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            vm.appointments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 56,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No appointments yet",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vm.appointments.length,
                    itemBuilder: (context, index) {
                      final a = vm.appointments[index];
                      return AppointmentCard(appointment: a, vm: vm);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
