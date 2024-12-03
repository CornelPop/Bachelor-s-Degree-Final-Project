import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_controller_app/AuthFeature/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../TrainingProgramsFeature/models/TrainingProgram.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserField(String uid, String fieldName, dynamic newValue) async {
    await _firestore.collection('users').doc(uid).update({fieldName: newValue});
  }

  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    await _firestore.collection('users').doc(uid).update(fields);
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(uid).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('User does not exist in Firestore.');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> storeUserUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }

  Future<String?> getUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<void> addCompletedProgram(String userId, TrainingProgram program) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    program.updateDate(DateTime.now());

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('completedPrograms')
          .add(program.toMap());
    } catch (e) {
      print("Error adding completed program: $e");
    }
  }

  Future<List<TrainingProgram>> getCompletedPrograms(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('completedPrograms')
          .get();

      return querySnapshot.docs
          .map((doc) => TrainingProgram.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error getting completed programs: $e");
      return [];
    }
  }

}
