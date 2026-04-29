import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:room_rental/widgets/info.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appt;
  final bool showUpcoming;

  const AppointmentCard({
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
                color: Colors.black.withOpacity(0.1),
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
                _statusBox(Colors.red, Icons.cancel, "Cancelled by admin"),

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
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: infoBox(Icons.calendar_today, date)),
                  SizedBox(width: 10),
                  Expanded(child: infoBox(Icons.access_time, time)),
                ],
              ),

              SizedBox(height: 14),
              if (showUpcoming)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Reschedule"),
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
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          SizedBox(width: 8),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
