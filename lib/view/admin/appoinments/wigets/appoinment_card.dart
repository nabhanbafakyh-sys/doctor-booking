import 'package:flutter/material.dart';
import 'package:room_rental/view/admin/appoinments/wigets/status_card.dart';
import 'package:room_rental/view_model/admin/appoinment_fetch.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final AdminDashboardViewModel vm;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    final a = appointment;
    final status = (a['status'] ?? 'pending') as String;

    final statusColor = switch (status) {
      'confirmed' => Colors.green,
      'cancelled' => Colors.red,
      _ => Colors.orange,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                a['userName'] ?? 'Unknown',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),
          InfoRow(
            icon: Icons.person_outline,
            text: 'Dr. ${a['doctorName'] ?? '—'}',
          ),
          InfoRow(icon: Icons.access_time_outlined, text: a['time'] ?? '—'),
          InfoRow(icon: Icons.calendar_today_outlined, text: a['date'] ?? '—'),
          if (status == 'cancelled' && a['cancelReason'] != null) ...[
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a['cancelledBy'] == 'admin'
                        ? "Cancelled by Admin"
                        : "Cancelled by User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(a['cancelReason'], style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final controller = TextEditingController();

                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Cancel Appointment"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Enter reason"),
                              const SizedBox(height: 10),
                              TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: "Reason...",
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 2,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (controller.text.trim().isEmpty) return;
                                Navigator.pop(context, true);
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await vm.cancel(a['id'], controller.text.trim());
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Appointment cancelled")),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Cancel"),
                  ),
                ),

                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => vm.approve(a['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Approve"),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
