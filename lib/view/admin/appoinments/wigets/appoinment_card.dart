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
            color: Colors.black.withOpacity(0.04),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
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
          const SizedBox(height: 8),
          InfoRow(
            icon: Icons.person_outline,
            text: 'Dr. ${a['doctorName'] ?? '—'}',
          ),
          InfoRow(icon: Icons.access_time_outlined, text: a['time'] ?? '—'),
          InfoRow(icon: Icons.calendar_today_outlined, text: a['date'] ?? '—'),

          // Only show action buttons if not already resolved
          if (status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => vm.cancel(a['id']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
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
