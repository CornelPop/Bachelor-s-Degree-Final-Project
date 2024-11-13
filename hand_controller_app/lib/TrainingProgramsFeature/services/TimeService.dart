import 'dart:async';
import 'package:flutter/material.dart';

class TimeService {
  Timer? _countdownTimer;
  late AnimationController _animationController;
  int _currentTime = 5;

  TimeService(TickerProvider tickerProvider) {
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: Duration(seconds: 5),
    );
  }

  Animation<double> get animation => Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
  int get currentTime => _currentTime;

  void startCountdown(VoidCallback onTick, VoidCallback onComplete) {
    _cancelExistingTimer();
    _animationController.reset();
    _animationController.forward();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      onTick();
      _currentTime--;
      if (_currentTime == 0) {
        _cancelExistingTimer();
        onComplete();
      }
    });
  }

  void _cancelExistingTimer() {
    if (_countdownTimer?.isActive ?? false) {
      _countdownTimer?.cancel();
    }
  }

  void dispose() {
    _cancelExistingTimer();
    _animationController.dispose();
  }
}
