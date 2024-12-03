import 'package:flutter/material.dart';

import '../../GlobalThemeData.dart';
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
    Color? iconColor;
    List<double> opacities;
    Color bgColor;

    if (difficulty == 'Beginner') {
      iconColor = Colors.blue[900];
      opacities = [1.0, 0.3, 0.3];
      bgColor = CustomTheme.accentColor;
    } else if (difficulty == 'Intermediate') {
      iconColor = Colors.blue[900];
      opacities = [1.0, 1.0, 0.3];
      bgColor = CustomTheme.accentColor2;
    } else {
      iconColor = Colors.blue[900];
      opacities = [1.0, 1.0, 1.0];
      bgColor = CustomTheme.accentColor3;
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
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.white),),
            Text(subtitle, style: TextStyle(color: Colors.white),),
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

