import 'dart:async';
import 'package:flutter/material.dart';

import '../models/TrainingProgram.dart';

class StartTrainingProgramScreen extends StatefulWidget {
  final TrainingProgram program;

  const StartTrainingProgramScreen({Key? key, required this.program}) : super(key: key);

  @override
  _StartTrainingProgramScreenState createState() => _StartTrainingProgramScreenState();
}

class _StartTrainingProgramScreenState extends State<StartTrainingProgramScreen> with TickerProviderStateMixin {
  Timer? _countdownTimer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentTime = 5;
  int _currentExerciseIndex = -1;
  bool _isExerciseActive = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _startCountdown();
  }

  void _startCountdown() {
    _cancelExistingTimer();
    _animationController.reset();
    _animationController.forward();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime--;
        if (_currentTime == 0) {
          _cancelExistingTimer();
          _startExercise();
        }
      });
    });
  }

  void _cancelExistingTimer() {
    if (_countdownTimer?.isActive ?? false) {
      _countdownTimer?.cancel();
    }
  }

  void _startExercise() {
    if (_isExerciseActive) return;
    _isExerciseActive = true;

    setState(() {
      _currentExerciseIndex++;
      _currentTime = 5;
    });

    _animationController.reset();
    _animationController.forward();

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime--;
        if (_currentTime == 0) {
          _cancelExistingTimer();
          _isExerciseActive = false;
          if (_currentExerciseIndex < widget.program.exercises.length - 1) {
            _startExercise();
          } else {
            _showCompletionDialog();
          }
        }
      });
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Program Completed"),
        content: Text("Congratulations! You have completed the program."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cancelExistingTimer();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.program.name),
      ),
      body: Center(
        child: _currentExerciseIndex == -1
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Get ready to start the program!",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildCountdownTimer(),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.program.exercises[_currentExerciseIndex].name,
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _buildCountdownTimer(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _cancelExistingTimer();
                if (_currentExerciseIndex < widget.program.exercises.length - 1) {
                  _isExerciseActive = false;
                  _startExercise();
                } else {
                  _showCompletionDialog();
                }
              },
              child: Text("Next Exercise"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              );
            },
          ),
        ),
        Text(
          '$_currentTime',
          style: TextStyle(fontSize: 48),
        ),
      ],
    );
  }
}
