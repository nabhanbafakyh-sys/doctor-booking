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
          appBar: AppBar(title: Text("Appointment History")),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => vm.toggleTab(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: vm.showUpcoming
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Upcoming",
                              style: TextStyle(
                                color: vm.showUpcoming
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => vm.toggleTab(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !vm.showUpcoming
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Past",
                              style: TextStyle(
                                color: !vm.showUpcoming
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Expanded(
                  child: vm.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : vm.filteredAppointments.isEmpty
                      ? Center(child: Text("No appointments"))
                      : ListView.builder(
                          itemCount: vm.filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appt = vm.filteredAppointments[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            (appt['imageUrl'] != null &&
                                                appt['imageUrl']
                                                    .toString()
                                                    .isNotEmpty)
                                            ? NetworkImage(appt['imageUrl'])
                                            : null,
                                        child: appt['imageUrl'] == null
                                            ? Icon(Icons.person)
                                            : null,
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              appt['doctorName'] ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              appt['specialization'] ?? '',
                                              style: TextStyle(
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          vm.showUpcoming ? "UPCOMING" : "PAST",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16),
                                      SizedBox(width: 5),
                                      Text(appt['date'] ?? ''),

                                      SizedBox(width: 20),

                                      Icon(Icons.access_time, size: 16),
                                      SizedBox(width: 5),
                                      Text(appt['time'] ?? ''),
                                    ],
                                  ),

                                  SizedBox(height: 15),
                                  if (vm.showUpcoming)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              // TODO cancel
                                            },
                                            child: Text("Cancel"),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // TODO reschedule
                                            },
                                            child: Text("Reschedule"),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
