import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_rental/view_model/user/booking_doctor.dart';

Widget timeChip(BuildContext context, String time) {
  final vm = context.watch<BookingVM>();
  final isSelected = vm.selectedtime == time;

  return ChoiceChip(
    label: Text(time),
    selected: isSelected,
    selectedColor: Colors.green[800],
    onSelected: (_) => vm.picktime(time),
    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
  );
}
