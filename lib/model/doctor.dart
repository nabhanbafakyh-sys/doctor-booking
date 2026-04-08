class DoctorModel {
  String id;
  String name;
  String specialization;
  String image;
  double rating;
  String hospital;

  DoctorModel({
    this.id = '',
    required this.name,
    required this.specialization,
    required this.image,
    required this.rating,
    required this.hospital,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json, String id) {
    return DoctorModel(
      id: id,
      name: json['name'],
      specialization: json['specialization'],
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
      hospital: json['hospital'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialization': specialization,
      'image': image,
      'rating': rating,
      'hospital': hospital,
    };
  }
}
