import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_controller_app/AuthFeature/services/UserService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService userService = UserService();

  Future<String?> register(String email, String password, String name, String role) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Encryption
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromLength(16);
      final encrypted = encrypt.Encrypter(encrypt.AES(key));

      final encryptedPassword = encrypted.encrypt(password, iv: iv).base64;

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'createdAt': Timestamp.now(),
        'role': role,
        'email': email,
        'password': encryptedPassword,
        'numberBeginnerExercises': 0,
        'numberIntermediateExercises': 0,
        'numberDifficultExercises': 0,
        'timeSpentInWorkouts': 0,
        'accuracyOfExercises': 0,
      });

      return 'User registered: ${userCredential.user!.email}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userService.storeUserUid(userCredential.user!.uid);
      print(userCredential.user!.uid);

      return 'User signed in: ${userCredential.user!.email}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return 'User signed out';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
