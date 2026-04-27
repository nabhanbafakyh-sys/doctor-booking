class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final double rating;
  final String image;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.rating,
    required this.image,
  });

  factory DoctorModel.fromFirestore(Map<String, dynamic> data, String id) {
    return DoctorModel(
      id: id,
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      hospital: data['hospital'] ?? '',
      rating: data['rating'] is double
          ? data['rating']
          : double.tryParse(data['rating'].toString()) ?? 0.0,
      image: data['image'] ?? '',
    );
  }
}
