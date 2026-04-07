import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/appoinment_VM.dart';

class UserAppointments extends StatelessWidget {
  const UserAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentViewModel>(
      builder: (context, vm, child) {
        if (vm.appointments.isEmpty && !vm.isLoading) {
          Future.microtask(() => vm.fetchAppointments());
        }

        return Scaffold(
          appBar: AppBar(title: const Text("My Appointments")),

          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : vm.appointments.isEmpty
              ? const Center(child: Text("No appointments yet"))
              : ListView.builder(
                  itemCount: vm.appointments.length,
                  itemBuilder: (context, index) {
                    final appt = vm.appointments[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 Top Row (Image + Name + Status)
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    (appt['imageUrl'] != null &&
                                        appt['imageUrl'].toString().isNotEmpty)
                                    ? NetworkImage(appt['imageUrl'])
                                    : null,
                                child: appt['imageUrl'] == null
                                    ? const Icon(Icons.person)
                                    : null,
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appt['doctorName'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      appt['specialization'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "UPCOMING",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// 🔹 Date + Time Row
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 5),
                              Text(appt['date'] ?? ''),

                              const SizedBox(width: 20),

                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 5),
                              Text(appt['time'] ?? ''),
                            ],
                          ),

                          const SizedBox(height: 15),

                          /// 🔹 Buttons
                          Row(
                            children: [
                              /// Cancel Button
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    // TODO: cancel logic
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// Reschedule Button
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // TODO: reschedule logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E2A78),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Reschedule",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
