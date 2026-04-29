import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view/admin/appoinments/wigets/appoinment_card.dart';
import 'package:room_rental/view/user/appoinment/widget/appoinment_card.dart';
import 'package:room_rental/widgets/info.dart';
import 'package:room_rental/widgets/tabs.dart';
import 'package:room_rental/view_model/user/appoinment_vm.dart';
import 'package:room_rental/view_model/user/user_bottom_bar.dart';

class UserAppointments extends StatelessWidget {
  const UserAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentViewModel>(
      builder: (context, vm, child) {
        if (vm.appointments.isEmpty && vm.isLoading) ;
        final navVM = context.read<UserBottomBarvm>();
        return PopScope(
          canPop: navVM.selectedpage == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && navVM.selectedpage != 0) {
              navVM.changepage(0);
            }
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
                            return AppointmentCard(
                              appt: appt,
                              showUpcoming: vm.showUpcoming,
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
