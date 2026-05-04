import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/user/appoinment_vm.dart';
import 'package:room_rental/widgets/info.dart';

class userAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appt;
  final bool showUpcoming;

  const userAppointmentCard({
    super.key,
    required this.appt,
    required this.showUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(appt['date']);
    } catch (e) {
      parsedDate = DateTime.now();
    }

    String date = DateFormat('MMM dd, yyyy').format(parsedDate);
    String time = appt['time'] ?? '';

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.92,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.teal.shade400,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appt['doctorName'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          appt['specialization'] ?? '',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          appt['hospital'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: showUpcoming
                          ? Colors.green.shade50
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      showUpcoming ? "UPCOMING" : "PAST",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: showUpcoming ? Colors.green : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// STATUS
              if (appt['status'] == 'cancelled')
                _statusBox(Colors.red, Icons.cancel, "Cancelled"),
              if (appt['status'] == 'confirmed')
                _statusBox(
                  Colors.green,
                  Icons.check_circle,
                  "Appointment confirmed",
                ),
              if (appt['status'] == 'pending')
                _statusBox(
                  Colors.orange,
                  Icons.hourglass_top,
                  "Waiting for approval",
                ),
              if (appt['status'] == 'cancelled' && appt['cancelReason'] != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt['cancelledBy'] == 'admin'
                            ? "Cancelled by Clinic"
                            : "You cancelled this",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appt['cancelReason'],
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              /// DATE & TIME
              Row(
                children: [
                  Expanded(child: infoBox(Icons.calendar_today, date)),
                  const SizedBox(width: 10),
                  Expanded(child: infoBox(Icons.access_time, time)),
                ],
              ),

              const SizedBox(height: 14),

              /// CANCEL BUTTON
              if (showUpcoming && appt['status'] != 'cancelled')
                Row(
                  children: [
                    Expanded(
                      child: Consumer<AppointmentViewModel>(
                        builder: (context, vm, _) {
                          return OutlinedButton(
                            onPressed: vm.isCancelling
                                ? null
                                : () async {
                                    final controller = TextEditingController();

                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text("Cancel Appointment"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Please provide a reason",
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: controller,
                                              decoration: const InputDecoration(
                                                hintText: "Enter reason",
                                                border: OutlineInputBorder(),
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("No"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (controller.text
                                                  .trim()
                                                  .isEmpty) {
                                                return;
                                              }
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text(
                                              "Yes",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true && context.mounted) {
                                      final id = appt['id'];
                                      if (id != null) {
                                        await vm.cancelBooking(
                                          id,
                                          controller.text.trim(),
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Appointment cancelled",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                            child: vm.isCancelling
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Cancel"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBox(Color color, IconData icon, String text) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
