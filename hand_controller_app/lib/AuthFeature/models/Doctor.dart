import 'User.dart';

class Doctor extends User {
  String specialization;
  double rating;
  int maxNoOfPatients;

  Doctor({
    required String uid,
    required String createdAt,
    required String name,
    required String email,
    required String password,
    required String role,
    required String dateOfBirth,
    required String phoneNumber,
    required String gender,
    this.specialization = 'Unknown',
    this.rating = 0.0,
    this.maxNoOfPatients = 0,
  }) : super(uid: uid, createdAt: createdAt, gender: gender, name: name, email: email, password: password, role: role, phoneNumber: phoneNumber, dateOfBirth: dateOfBirth);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'specialization': specialization,
      'rating': rating,
    });
    return baseMap;
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      uid: map['uid'],
      createdAt: map['createdAt'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      specialization: map['specialization'] ?? 'Unknown',
      rating: map['rating'] ?? 0.0,
      phoneNumber: map['phoneNumber'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
    );
  }
}
