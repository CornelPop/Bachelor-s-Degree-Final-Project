import 'dart:async'; // Import the dart:async library to use Timer
import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/UserService.dart';
import 'package:http/http.dart' as http;

import '../models/MockDataTrainingPrograms.dart';
import '../models/TrainingProgram.dart';
import 'ProgramDetailsScreen.dart';

class TrainingProgramScreen extends StatelessWidget {
  const TrainingProgramScreen({Key? key}) : super(key: key);

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
              )
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
        body: const TrainingProgramDashboard(),
      ),
    );
  }
}

class TrainingProgramDashboard extends StatefulWidget {
  const TrainingProgramDashboard({Key? key}) : super(key: key);

  @override
  _TrainingProgramDashboardState createState() => _TrainingProgramDashboardState();
}

class _TrainingProgramDashboardState extends State<TrainingProgramDashboard> {

  final UserService userService = UserService();

  final String esp32IpAddress = "http://192.168.211.136";
  String flexSensorValue = '';
  Timer? timer; // Declare a Timer variable
  bool isTimerRunning = false; // Track the timer state
  int progressPercentage = 0; // Track the progress percentage

  TrainingProgram? selectedProgram; // Currently selected training program
  int currentExerciseIndex = 0; // Index of the current exercise
  Map<String, int> currentFlexValues = {}; // Store current flex values

  late double screenWidth;
  late double screenHeight;
  late double buttonWidth;
  late double buttonHeight;
  late double containerHeight;

  String name = '';

  @override
  void initState() {
    super.initState();
    fetchUserData(userService);
  }

  void fetchUserData(UserService userService) async {
    String? uid = await userService.getUserUid();
    print("here");
    print(uid);
    print("here");
    if (uid != null) {
      Map<String, dynamic>? userData = await userService.getUserData(uid);
      if (userData != null) {
        name = (userData['name'] as String?)!;
        String? email = userData['email'] as String?;
        String? role = userData['role'] as String?;

        int? numberBeginnerExercises = userData['numberBeginnerExercises'] as int?;
        int? numberIntermediateExercises = userData['numberIntermediateExercises'] as int?;
        int? numberDifficultExercises = userData['numberDifficultExercises'] as int?;
        int? timeSpentInWorkouts = userData['timeSpentInWorkouts'] as int?;
        int? accuracyOfExercises = userData['accuracyOfExercises'] as int?;

      } else {
        print('No user data found.');
      }
    } else {
      print('No UID found in SharedPreferences.');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData(userService);

    var screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    buttonWidth = screenWidth * 0.90;
    buttonHeight = screenHeight * 0.08;
    containerHeight = screenHeight * 0.15;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.2,
            child: SingleChildScrollView(
              child: Text(message),
            ),
          ),
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

  void showExercisesDialog(TrainingProgram program) {
    setState(() {
      selectedProgram = program;
      currentExerciseIndex = 0;
      progressPercentage = 0;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(program.name),
          content: SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.2,
            child: SingleChildScrollView(
              child: ListBody(
                children: program.exercises.map((exercise) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...exercise.targetValues.entries
                          .map((entry) => Text('${entry.key}: ${entry.value}'))
                          .toList(),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Start'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TrainingProgram> programs = getTrainingPrograms();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: screenHeight * 0.02),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Opacity(
                      opacity: 0.7,
                      child: Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Your stats',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(height: screenHeight * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                height: screenHeight * 0.35,
                //color: Colors.lightBlue,
                child: Row(
                  children: [
                    // First container with less space
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.insert_chart,
                                        color: Colors.red, size: 40),
                                    Text(
                                      '84%',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Accuracy'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8.0, top: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.timer,
                                        color: Colors.red, size: 40),
                                    Text(
                                      '78 min',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text('Time Spent'),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.bolt,
                                        color: Color.fromARGB(255, 0, 158, 0), size: 30),
                                    const Opacity(
                                      opacity: 0.3,
                                      child: Icon(Icons.bolt,
                                          color: Color.fromARGB(255, 0, 158, 0), size: 30),
                                    ),
                                    const Opacity(
                                      opacity: 0.3,
                                      child: Icon(Icons.bolt,
                                          color: Color.fromARGB(255, 0, 158, 0), size: 30),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            '107',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text('Exercises'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 4.0, left: 8.0, top: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.bolt,
                                        color: Color.fromARGB(255, 255, 140, 0), size: 30),
                                    const Icon(Icons.bolt,
                                        color: Color.fromARGB(255, 255, 140, 0), size: 30),
                                    const Opacity(
                                      opacity: 0.3,
                                      child: Icon(Icons.bolt,
                                          color: Color.fromARGB(255, 255, 140, 0), size: 30),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            '67',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text('Exercises'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8.0, top: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.bolt,
                                        color: Color.fromARGB(255, 200, 0, 0), size: 30),
                                    const Icon(Icons.bolt,
                                        color: Color.fromARGB(255, 200, 0, 0), size: 30),
                                    const Icon(Icons.bolt,
                                        color: Color.fromARGB(255, 200, 0, 0), size: 30),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            '21',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text('Exercises'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: screenHeight * 0.02), // 2% of the screen height
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Beginner',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(height: screenHeight * 0.01), // 2% of the screen height
            Container(
              alignment: Alignment.centerLeft,
              height: screenHeight * 0.17,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final program = programs[index];
                  if (program.category.compareTo('Beginner') == 0) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: programContainer(
                        program: program,
                        title: program.name,
                        subtitle: '${program.duration} MINS  ●  ${program.exercises.length} EXERCISES',
                        difficulty: program.category,
                      ),
                    );
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),
            Container(height: screenHeight * 0.02), // 2% of the screen height
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Intermediate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(height: screenHeight * 0.01), // 2% of the screen height
            Container(
              height: screenHeight * 0.17,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final program = programs[index];
                  if (program.category.compareTo('Intermediate') == 0) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0),
                      child: programContainer(
                        program: program,
                        title: program.name,
                        subtitle: '${program.duration} MINS  ●  ${program.exercises.length} EXERCISES',
                        difficulty: program.category,
                      ),
                    );
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),
            Container(height: screenHeight * 0.02), // 2% of the screen height
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Difficult',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(height: screenHeight * 0.01), // 2% of the screen height
            Container(
              height: screenHeight * 0.17,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: programs.length,
                itemBuilder: (context, index) {
                  final program = programs[index];
                  if (program.category.compareTo('Difficult') == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        child: programContainer(
                          program: program,
                          title: program.name,
                          subtitle: '${program.duration} MINS  ●  ${program.exercises.length} EXERCISES',
                          difficulty: program.category,
                        ),
                      ),
                    );
                  }
                  else {
                    return Container();
                  }
                },
              ),
            ),
            Container(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget programContainer({
    required TrainingProgram program,
    required String title,
    required String subtitle,
    required String difficulty,
  }) {
    Color iconColor;
    List<double> opacities;

    if (difficulty == 'Beginner') {
      iconColor = const Color.fromARGB(255, 0, 158, 0);
      opacities = [1.0, 0.3, 0.3];
    } else if (difficulty == 'Intermediate') {
      iconColor = const Color.fromARGB(255, 255, 140, 0);
      opacities = [1.0, 1.0, 0.3];
    } else { // Difficult
      iconColor = const Color.fromARGB(255, 200, 0, 0);
      opacities = [1.0, 1.0, 1.0];
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
            builder: (context) => ProgramDetailsScreen(program: program))
        );
      },
      child: Container(
        height: screenHeight * 0.15,
        width: buttonWidth * 0.7,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            Text(subtitle),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Opacity(
                  opacity: opacities[index],
                  child: Icon(Icons.bolt, color: iconColor, size: 30),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}