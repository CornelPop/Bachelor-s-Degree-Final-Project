import '../../ProfileFeature/models/MedicalHistory.dart';
import 'User.dart';

class Patient extends User {
  int numberBeginnerExercises;
  int numberIntermediateExercises;
  int numberDifficultExercises;
  int timeSpentInWorkouts;
  String doctorId;
  double accuracyOfExercises;

  Patient({
    required String uid,
    required String createdAt,
    required String name,
    required String email,
    required String password,
    required String role,
    this.doctorId = '',
    this.numberBeginnerExercises = 0,
    this.numberIntermediateExercises = 0,
    this.numberDifficultExercises = 0,
    this.timeSpentInWorkouts = 0,
    this.accuracyOfExercises = 0.0,
  }) : super(uid: uid, createdAt: createdAt, name: name, email: email, password: password, role: role);

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'doctorId': doctorId,
      'numberBeginnerExercises': numberBeginnerExercises,
      'numberIntermediateExercises': numberIntermediateExercises,
      'numberDifficultExercises': numberDifficultExercises,
      'timeSpentInWorkouts': timeSpentInWorkouts,
      'accuracyOfExercises': accuracyOfExercises,
    });
    return baseMap;
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      uid: map['uid'],
      createdAt: map['createdAt'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      doctorId: map['doctorId'] ?? '',
      numberBeginnerExercises: map['numberBeginnerExercises'] ?? 0,
      numberIntermediateExercises: map['numberIntermediateExercises'] ?? 0,
      numberDifficultExercises: map['numberDifficultExercises'] ?? 0,
      timeSpentInWorkouts: map['timeSpentInWorkouts'] ?? 0,
      accuracyOfExercises: map['accuracyOfExercises'] ?? 0.0
    );
  }
}
