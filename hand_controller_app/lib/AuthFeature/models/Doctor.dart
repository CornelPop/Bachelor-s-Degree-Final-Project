import 'User.dart';

class Doctor extends User {
  String specialization;
  double rating;

  Doctor({
    required String uid,
    required String createdAt,
    required String name,
    required String email,
    required String password,
    required String role,
    this.specialization = 'Unknown',
    this.rating = 0.0,
  }) : super(uid: uid, createdAt: createdAt, name: name, email: email, password: password, role: role);

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
    );
  }
}
