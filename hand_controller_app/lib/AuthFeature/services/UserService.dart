import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hand_controller_app/AuthFeature/models/Doctor.dart';
import 'package:hand_controller_app/AuthFeature/models/Patient.dart';
import 'package:hand_controller_app/ProfileFeature/models/MedicalHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ProfileFeature/models/Rating.dart';
import '../../TrainingProgramsFeature/models/TrainingProgram.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserField(
      String uid, String fieldName, dynamic newValue) async {
    await _firestore.collection('users').doc(uid).update({fieldName: newValue});
  }

  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    await _firestore.collection('users').doc(uid).update(fields);
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(uid).get();
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

  Future<void> addCompletedProgram(
      String userId, TrainingProgram program) async {
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
          .map((doc) =>
              TrainingProgram.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error getting completed programs: $e");
      return [];
    }
  }

  Future<List<dynamic>> getUsersByRole(String role) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (role == 'Doctor') {
          return Doctor.fromMap(data);
        } else if (role == 'Patient') {
          print('ceva');

          return Patient.fromMap(data);
        }

        return data;
      }).toList();
    } catch (e) {
      print('Error fetching users by role: $e');
      return [];
    }
  }

  Future<List<Patient>> getPatientsByDoctorId(String doctorId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Patient')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Patient.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching patients by doctorId: $e');
      return [];
    }
  }


  Future<String?> getUserRoleByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      Map<String, dynamic> data =
          querySnapshot.docs.first.data() as Map<String, dynamic>;
      return data['role'] as String?;
    } catch (e) {
      print('Error fetching user role by email: $e');
      return null;
    }
  }
}
