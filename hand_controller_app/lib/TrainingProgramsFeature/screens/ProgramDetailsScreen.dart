import 'package:flutter/material.dart';

import '../models/TrainingProgram.dart';
import 'StartTrainingProgramScreen.dart';

class ProgramDetailsScreen extends StatelessWidget {
  final TrainingProgram program;

  const ProgramDetailsScreen({Key? key, required this.program})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 160.0,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                program.name,
                style: TextStyle(fontSize: 20.0),
              ),
              background: FlutterLogo(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    '${program.duration} MINS  ●  ${program.exercises.length} EXERCISES',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: program.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = program.exercises[index];
                      return Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.bolt,
                                  color: Color.fromARGB(255, 0, 158, 0), size: 35),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    'x${exercise.numberOfTimes}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.bolt,
                                  color: Color.fromARGB(255, 0, 158, 0), size: 35),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StartTrainingProgramScreen(program: program))
              );
            },
            child: const Text('Start Program',
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
        ),
      ),
    );
  }
}
