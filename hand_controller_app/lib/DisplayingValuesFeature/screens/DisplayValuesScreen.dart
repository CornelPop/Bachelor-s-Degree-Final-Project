import 'dart:async'; // Import the dart:async library to use Timer
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/screens/SignInScreen.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/screens/TrainingProgramScreen.dart';
import 'package:http/http.dart' as http;

import '../../AuthFeature/services/UserService.dart';

class DisplayValuesScreen extends StatefulWidget {
  const DisplayValuesScreen({Key? key}) : super(key: key);

  @override
  _DisplayValuesScreenState createState() => _DisplayValuesScreenState();
}

class _DisplayValuesScreenState extends State<DisplayValuesScreen> {
  final String esp32IpAddress = "http://192.168.80.136";
  Map<String, int> currentFlexValues = {
    'Thumb': 0,
    'Index': 0,
    'Middle': 0,
    'Ring': 0,
    'Pinky': 0,
  };
  Timer? timer;
  bool isTimerRunning = false;
  String flexSensorValue = '';
  bool isRequestInProgress = false;

  final UserService userService = UserService();
  final AuthService authService = AuthService();

  String name = '';
  String email = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    String? uid = await userService.getUserUid();
    if (uid != null) {
      Map<String, dynamic>? userData = await userService.getUserData(uid);
      if (userData != null) {
        setState(() {
          name = userData['name'];
          email = userData['email'];
          role = userData['role'];
        });
      }
    }
  }

  Future<bool> _showExitDialog() async {
    bool exitConfirmed = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: const Text("Exit app"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () {
              exit(0);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
    return exitConfirmed;
  }

  void ledOn() async {
    var url = Uri.parse('$esp32IpAddress/LED=ON');
    await http.get(url);
  }

  void ledOff() async {
    var url = Uri.parse('$esp32IpAddress/LED=OFF');
    await http.get(url);
  }

  void startTimer() {
    if (!isTimerRunning) {
      isTimerRunning = true;
      timer = Timer.periodic(const Duration(milliseconds: 200), (Timer t) {
        readFlexSensor();
      });
    }
  }

  void stopTimer() {
    if (isTimerRunning) {
      timer?.cancel();
      isTimerRunning = false;
    }
  }

  void readFlexSensor() async {
    // Simulated sensor values; replace this with actual HTTP request
    setState(() {
      currentFlexValues = {
        'Thumb': (currentFlexValues['Thumb']! + 10) % 100,
        'Index': (currentFlexValues['Index']! + 15) % 100,
        'Middle': (currentFlexValues['Middle']! + 20) % 100,
        'Ring': (currentFlexValues['Ring']! + 25) % 100,
        'Pinky': (currentFlexValues['Pinky']! + 30) % 100,
      };
    });

    // if (isRequestInProgress) return; // Prevent overlapping requests
    //
    // isRequestInProgress = true;
    // var url = Uri.parse('$esp32IpAddress/FLEX=READ');
    // var response = await http.get(url);
    // if (response.statusCode == 200) {
    //   setState(() {
    //     flexSensorValue = response.body.substring(0, 3); // Extract the first 3 characters
    //     int sensorValue = int.parse(flexSensorValue);
    //
    //     // Validate the sensor value
    //     if (sensorValue >= 200 && sensorValue <= 800) {
    //       double normalizedValue = (sensorValue - 200) / (800 - 200); // Normalize to 0-1 range
    //       currentFlexValues['Thumb'] = (normalizedValue * 100).toInt(); // Update thumb value
    //     }
    //   });
    // } else {
    //   print('Failed to read flex sensor: ${response.statusCode}'); // Log an error if reading fails
    // }
    // isRequestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog();
      },
      child: Scaffold(
        drawer: Drawer(
          width: 250,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                    )
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_outline, size: 70,),
                      Text(name, style: TextStyle(fontSize: 30),)
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Dashboard Programs'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TrainingProgramScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Dashboard Values'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Progress Tracking'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Sign out'),
                onTap: () async {
                  await authService.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          title: const Text('HandHero'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildProgressBar('Thumb', currentFlexValues['Thumb']!),
              buildProgressBar('Index', currentFlexValues['Index']!),
              buildProgressBar('Middle', currentFlexValues['Middle']!),
              buildProgressBar('Ring', currentFlexValues['Ring']!),
              buildProgressBar('Pinky', currentFlexValues['Pinky']!),
              if (flexSensorValue.isNotEmpty)
                Text('Flex Sensor Value: $flexSensorValue'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $value'),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value / 100),
            duration: const Duration(milliseconds: 300),
            builder: (context, double progress, _) {
              return LinearProgressIndicator(
                value: progress,
                minHeight: 30,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              );
            },
          ),
        ],
      ),
    );
  }
}
