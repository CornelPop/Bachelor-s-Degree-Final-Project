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
          title: const Text('ESP32 LED Control'),
        ),
        body: const ControlPanel(),
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  final String esp32IpAddress = "http://192.168.1.10";

  const ControlPanel({Key? key}) : super(key: key);

  void ledOn() async {
    var url = Uri.parse('$esp32IpAddress/LED=ON');
    await http.get(url);
  }

  void ledOff() async {
    var url = Uri.parse('$esp32IpAddress/LED=OFF');
    await http.get(url);
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
        ],
      ),
    );
  }
}
