import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/user/appoinment/widgets/info.dart';
import 'package:room_rental/view/user/appoinment/widgets/tabs.dart';
import 'package:room_rental/view/user/bottom/bottom_navigation.dart';
import 'package:room_rental/view_model/user/appoinment_VM.dart';

class UserAppointments extends StatelessWidget {
  const UserAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentViewModel>(
      builder: (context, vm, child) {
        if (vm.appointments.isEmpty && vm.isLoading) {
          vm.listenAppointments();
        }

        return WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => UserBottomNav()),
            );
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text("Appointments"),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      tab("Upcoming", vm.showUpcoming, () {
                        vm.toggleTab(true);
                      }),
                      tab("Past", !vm.showUpcoming, () {
                        vm.toggleTab(false);
                      }),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : vm.filteredAppointments.isEmpty
                      ? Center(child: Text("No appointments"))
                      : ListView.builder(
                          itemCount: vm.filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appt = vm.filteredAppointments[index];
                            DateTime parsedDate;
                            try {
                              parsedDate = DateTime.parse(
                                appt['date'].toString().split(" ")[0],
                              );
                            } catch (e) {
                              parsedDate = DateTime.now();
                            }
                            String date = DateFormat(
                              'MMM dd, yyyy',
                            ).format(parsedDate);
                            String time = appt['time'] ?? '';
                            return Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.92,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 14,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 28,
                                            backgroundColor:
                                                Colors.blue.shade50,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  appt['doctorName'] ?? '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  appt['specialization'] ?? '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                  ),
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
                                              color: vm.showUpcoming
                                                  ? Colors.green.shade50
                                                  : Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              vm.showUpcoming
                                                  ? "UPCOMING"
                                                  : "PAST",
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: vm.showUpcoming
                                                    ? Colors.green
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 14),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: infoBox(
                                              Icons.calendar_today,
                                              date,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: infoBox(
                                              Icons.access_time,
                                              time,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 14),
                                      if (vm.showUpcoming)
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {},
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                ),
                                                child: Text("Cancel"),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30,
                                                        ),
                                                  ),
                                                ),
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
