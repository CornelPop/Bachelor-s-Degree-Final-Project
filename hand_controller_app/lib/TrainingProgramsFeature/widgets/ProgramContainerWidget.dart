import 'package:flutter/material.dart';

import '../models/TrainingProgram.dart';
import '../screens/ProgramDetailsScreen.dart';

class ProgramContainer extends StatelessWidget {
  final TrainingProgram program;
  final String title;
  final String subtitle;
  final String difficulty;

  ProgramContainer({
    required this.program,
    required this.title,
    required this.subtitle,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    List<double> opacities;

    if (difficulty == 'Beginner') {
      iconColor = const Color.fromARGB(255, 0, 158, 0);
      opacities = [1.0, 0.3, 0.3];
    } else if (difficulty == 'Intermediate') {
      iconColor = const Color.fromARGB(255, 255, 140, 0);
      opacities = [1.0, 1.0, 0.3];
    } else {
      // Difficult
      iconColor = const Color.fromARGB(255, 200, 0, 0);
      opacities = [1.0, 1.0, 1.0];
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgramDetailsScreen(program: program),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.7,
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
