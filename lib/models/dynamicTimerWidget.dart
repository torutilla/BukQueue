import 'dart:async';

import 'package:flutter/material.dart';

class DynamicTimerWidget extends StatefulWidget {
  final int timeInSeconds;

  DynamicTimerWidget({required this.timeInSeconds});

  @override
  _DynamicTimerWidgetState createState() => _DynamicTimerWidgetState();
}

class _DynamicTimerWidgetState extends State<DynamicTimerWidget> {
  late Timer _timer;
  late int _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.timeInSeconds;
    _startTimer();
  }

  // Converts seconds into minutes and seconds format
  String getFormattedTime() {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return "${minutes}m ${seconds}s";
  }

  // Starts the timer and updates the state
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getFormattedTime(),
      style: TextStyle(
        fontSize: 12,
      ),
    );
  }
}
