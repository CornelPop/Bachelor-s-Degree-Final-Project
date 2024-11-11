import 'Exercise.dart';
import 'TrainingProgram.dart';

List<TrainingProgram> getTrainingPrograms() {
  Exercise exercise1 = Exercise(
    name: 'Fingers Flex',
    description: '',
    numberOfTimes: 10,
    targetValues: {'Thumb': 600, 'Index': 600, 'Middle': 600, 'Ring': 600, 'Pinky': 600},
  );

  Exercise exercise2 = Exercise(
    name: 'Fingers Relax',
    description: '',
    numberOfTimes: 10,
    targetValues: {'Thumb': 200, 'Index': 200, 'Middle': 200, 'Ring': 200, 'Pinky': 200}
  );

  TrainingProgram program1 = TrainingProgram(
    name: 'Beginner Program',
    category: 'Beginner',
    duration: 10,
    exercises: [exercise1],
  );

  TrainingProgram program2 = TrainingProgram(
    name: 'Beginner Program',
    category: 'Beginner',
    duration: 10,
    exercises: [exercise1],
  );

  TrainingProgram program3 = TrainingProgram(
    name: 'Intermediate Program',
    category: 'Intermediate',
    duration: 15,
    exercises: [exercise1, exercise2, exercise1, exercise2],
  );

  TrainingProgram program4 = TrainingProgram(
    name: 'Intermediate Program',
    category: 'Intermediate',
    duration: 15,
    exercises: [exercise1, exercise2, exercise1, exercise2],
  );

  TrainingProgram program5 = TrainingProgram(
    name: 'Difficult Program',
    category: 'Difficult',
    duration: 20,
    exercises: [exercise1, exercise2, exercise1, exercise2, exercise1, exercise2],
  );

  TrainingProgram program6 = TrainingProgram(
    name: 'Difficult Program',
    category: 'Difficult',
    duration: 20,
    exercises: [exercise1, exercise2, exercise1, exercise2, exercise1, exercise2],
  );

  return [program1, program2, program3, program4, program5, program6];
}
