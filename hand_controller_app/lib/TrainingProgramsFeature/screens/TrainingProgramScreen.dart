import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hand_controller_app/AuthFeature/services/AuthService.dart';
import 'package:hand_controller_app/AuthFeature/services/UserService.dart';
import 'package:hand_controller_app/TrainingProgramsFeature/widgets/TrainingProgramDashboardDrawer.dart';
import '../models/MockDataTrainingPrograms.dart';
import '../models/TrainingProgram.dart';
import '../widgets/ProgramContainerWidget.dart';

class TrainingProgramScreen extends StatefulWidget {
  const TrainingProgramScreen({Key? key}) : super(key: key);

  @override
  _TrainingProgramScreenState createState() => _TrainingProgramScreenState();
}

class _TrainingProgramScreenState extends State<TrainingProgramScreen> {

  final UserService userService = UserService();
  final AuthService authService = AuthService();

  String name = '';
  String email = '';
  String role = '';

  String flexSensorValue = '';
  Timer? timer;
  bool isTimerRunning = false;
  int progressPercentage = 0;

  TrainingProgram? selectedProgram;
  int currentExerciseIndex = 0;
  Map<String, int> currentFlexValues = {};

  late double screenWidth;
  late double screenHeight;
  late double buttonWidth;
  late double buttonHeight;
  late double containerHeight;

  int numberBeginnerExercises = 0;
  int numberIntermediateExercises = 0;
  int numberDifficultExercises = 0;
  int timeSpentInWorkouts = 0;
  int accuracyOfExercises = 0;

  late Future<void> _fetchUserDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserDataFuture = fetchUserData();
  }

  Future<void> fetchUserData() async {
    String? uid = await userService.getUserUid();
    if (uid != null) {
      Map<String, dynamic>? userData = await userService.getUserData(uid);
      if (userData != null) {
        setState(() {
          name = userData['name'] as String;
          email = userData['email'] as String;
          role = userData['role'] as String;

          numberBeginnerExercises = userData['numberBeginnerExercises'] as int;
          numberIntermediateExercises = userData['numberIntermediateExercises'] as int;
          numberDifficultExercises = userData['numberDifficultExercises'] as int;
          timeSpentInWorkouts = userData['timeSpentInWorkouts'] as int;
          accuracyOfExercises = userData['accuracyOfExercises'] as int;
        });
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

    var screenSize = MediaQuery.of(context).size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    buttonWidth = screenWidth * 0.90;
    buttonHeight = screenHeight * 0.08;
    containerHeight = screenHeight * 0.15;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: _buildDrawer(),
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
        body: FutureBuilder(
          future: _fetchUserDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return _buildContent();
            }
          },
        ),
      );
  }

  TrainingProgramDashboardDrawer _buildDrawer() {
    return TrainingProgramDashboardDrawer(
      name: name,
      authService: authService,
      userService: userService,
    );
  }

  Widget _buildContent() {
    List<TrainingProgram> programs = getTrainingPrograms();

    return FutureBuilder(
      future: _fetchUserDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
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
                            style: const TextStyle(
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
                                        children: [
                                          Icon(Icons.insert_chart,
                                              color: Colors.red, size: 40),
                                          Text(
                                            '$accuracyOfExercises',
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
                                        children: [
                                          Icon(Icons.timer,
                                              color: Colors.red, size: 40),
                                          Text(
                                            '$timeSpentInWorkouts',
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
                                              children: [
                                                Text(
                                                  '$numberBeginnerExercises',
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
                                              children: [
                                                Text(
                                                  '$numberIntermediateExercises',
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
                                              children: [
                                                Text(
                                                  '$numberDifficultExercises',
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
                            child: ProgramContainer(
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
                            child: ProgramContainer(
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
                              child: ProgramContainer(
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
      },
    );
  }
}
