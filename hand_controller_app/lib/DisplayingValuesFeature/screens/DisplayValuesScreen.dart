import 'dart:async'; // Import the dart:async library to use Timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisplayValuesScreen extends StatelessWidget {
  const DisplayValuesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          title: const Text('My amazing project'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person, size: 30,),
              onPressed: () {
                print("salut profile");
              },
            ),
          ],
        ),
        body: const DisplayValuesScreenDashboard(),
      ),
    );
  }
}

class DisplayValuesScreenDashboard extends StatefulWidget {
  const DisplayValuesScreenDashboard({Key? key}) : super(key: key);

  @override
  _DisplayValuesScreenDashboardState createState() => _DisplayValuesScreenDashboardState();
}

class _DisplayValuesScreenDashboardState extends State<DisplayValuesScreenDashboard> {
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

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
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
    return Padding(
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
            Text(
                'Flex Sensor Value: $flexSensorValue'),
        ],
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
