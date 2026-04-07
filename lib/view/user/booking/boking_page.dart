import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/booking_doctor.dart';

class BookingScreen extends StatelessWidget {
  final String doctorName;
  final String imageUrl;
  final String specialty;

  const BookingScreen({
    super.key,
    required this.doctorName,
    required this.imageUrl,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingVM>();

    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(specialty),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Select Date"),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  initialDate: DateTime.now(),
                );
                if (picked != null) {
                  vm.pickdate(picked);
                }
              },
              child: Text(
                vm.selecteddate == null
                    ? "Choose Date"
                    : vm.selecteddate.toString().split(" ")[0],
              ),
            ),
            SizedBox(height: 20),
            Text("Select Time"),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                _timeChip(context, "10:00 AM"),
                _timeChip(context, "11:00 AM"),
                _timeChip(context, "12:00 PM"),
                _timeChip(context, "2:00 PM"),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await vm.bookAppointment(
                  doctorName: doctorName,
                  userName: "User", // later dynamic
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Appointment Booked")),
                );

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Book Appointment"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeChip(BuildContext context, String time) {
    final vm = context.watch<BookingVM>();

    final isSelected = vm.selectedtime == time;

    return ChoiceChip(
      label: Text(time),
      selected: isSelected,
      onSelected: (_) => vm.picktime(time),
    );
  }
}
