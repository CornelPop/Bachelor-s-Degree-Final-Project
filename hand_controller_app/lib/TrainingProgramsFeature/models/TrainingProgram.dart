
import 'Exercise.dart';

class TrainingProgram {
  final String name;
  final String category;
  final int duration;
  final List<Exercise> exercises;

  TrainingProgram({
    required this.name,
    required this.duration,
    required this.category,
    required this.exercises,
  });
}