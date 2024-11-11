
class User {
  String uid;
  String createdAt;
  String name;
  String email;
  String password;
  String role;
  int numberBeginnerExercises;
  int numberIntermediateExercises;
  int numberDifficultExercises;
  int timeSpentInWorkouts;
  double accuracyOfExercises;

  User({
    required this.uid,
    required this.createdAt,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.numberBeginnerExercises,
    required this.numberIntermediateExercises,
    required this.numberDifficultExercises,
    required this.timeSpentInWorkouts,
    required this.accuracyOfExercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'createdAt': createdAt,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'numberBeginnerExercises': numberBeginnerExercises,
      'numberIntermediateExercises': numberIntermediateExercises,
      'numberDifficultExercises': numberDifficultExercises,
      'timeSpentInWorkouts': timeSpentInWorkouts,
      'accuracyOfExercises': accuracyOfExercises,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'],
      createdAt: map['createdAt'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      numberBeginnerExercises: map['numberBeginnerExercises'],
      numberIntermediateExercises: map['numberIntermediateExercises'],
      numberDifficultExercises: map['numberDifficultExercises'],
      timeSpentInWorkouts: map['timeSpentInWorkouts'],
      accuracyOfExercises: map['accuracyOfExercises'],
    );
  }
}
