class AppointmentModel {
  String doctorId;
  String date;
  String status;

  AppointmentModel({
    required this.doctorId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {'doctorId': doctorId, 'date': date, 'status': status};
  }
}
