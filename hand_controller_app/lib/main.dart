import 'dart:async'; // Import the dart:async library to use Timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ESP32 Control'),
        ),
        body: const ControlPanel(),
      ),
    );
  }
}

class ControlPanel extends StatefulWidget {
  const ControlPanel({Key? key}) : super(key: key);

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final String esp32IpAddress = "http://192.168.211.136";
  String flexSensorValue = '';
  Timer? timer; // Declare a Timer variable
  bool isTimerRunning = false; // Track the timer state

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    timer?.cancel();
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
      isTimerRunning = true; // Set the timer running state
      timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
        readFlexSensor();
      });
    }
  }

  void stopTimer() {
    if (isTimerRunning) {
      timer?.cancel(); // Cancel the timer
      isTimerRunning = false; // Update the timer state
    }
  }

  void readFlexSensor() async {
    var url = Uri.parse('$esp32IpAddress/FLEX=READ');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        flexSensorValue = response.body; // Update the state with the fetched value
      });

      // Check if the flex sensor value exceeds 750
      if (int.parse(flexSensorValue.substring(0, 3)) > 750) {
        stopTimer(); // Stop the timer if the value exceeds 750
        showAlertDialog(); // Show alert dialog
      }
    } else {
      print('Failed to read flex sensor: ${response.statusCode}'); // Log an error if reading fails
    }
  }

  void showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Movement achieved, Flex Sensor Value exceeded 750!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: ledOn,
            child: const Text('Turn LED ON'),
          ),
          ElevatedButton(
            onPressed: ledOff,
            child: const Text('Turn LED OFF'),
          ),
          ElevatedButton(
            onPressed: startTimer,
            child: const Text('Start Timer'),
          ),
          ElevatedButton(
            onPressed: stopTimer,
            child: const Text('Stop Timer'),
          ),
          if (flexSensorValue.isNotEmpty)
            Text('Flex Sensor Value: $flexSensorValue'), // Display the sensor value
        ],
      ),
    );
  }
}
