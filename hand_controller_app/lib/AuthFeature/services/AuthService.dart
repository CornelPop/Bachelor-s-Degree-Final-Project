import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_controller_app/AuthFeature/services/SharedPrefService.dart';
import 'package:hand_controller_app/AuthFeature/services/UserService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final UserService userService = UserService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final SharedPrefsService sharedPrefsService = SharedPrefsService();

  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final OAuthCredential credential =
      FacebookAuthProvider.credential(accessToken.token);
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      return userCredential.user;
    }
    return null;
  }

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

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      await userService.storeUserUid(userCredential.user!.uid);

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': googleUser.displayName,
          'createdAt': Timestamp.now(),
          'role': 'Patient',
          'email': googleUser.email,
          'numberBeginnerExercises': 0,
          'numberIntermediateExercises': 0,
          'numberDifficultExercises': 0,
          'timeSpentInWorkouts': 0,
          'accuracyOfExercises': 0,
        });
      }

      return user;
    } catch (e) {
      print(e);
      return null;
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
      await _googleSignIn.signOut();
      await sharedPrefsService.storeRememberMe(false);
      return 'User signed out';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> deleteAccount() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).delete();

        await user.delete();

        await _auth.signOut();

        return 'User deleted';
      } catch (e) {
        return 'Error: ${e.toString()}';
      }
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return 'password email sent';

    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

}
