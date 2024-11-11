import 'dart:async'; // Import the dart:async library to use Timer
import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/screens/SignInScreen.dart';
import 'package:hand_controller_app/DisplayingValuesFeature/screens/DisplayValuesScreen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'TrainingProgramsFeature/models/Exercise.dart';
import 'TrainingProgramsFeature/models/MockDataTrainingPrograms.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('ESP32 Control'),
        ),
        body: const SignInScreen(),
      ),
    );
  }
}