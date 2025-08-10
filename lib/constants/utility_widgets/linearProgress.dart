import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_try_thesis/constants/constants.dart';

class LinearProgressIndicatorWithTimer extends StatefulWidget {
  final int timeInMilliseconds;
  final Function() callBack;
  LinearProgressIndicatorWithTimer({
    super.key,
    required this.timeInMilliseconds,
    required this.callBack,
  });

  @override
  State<LinearProgressIndicatorWithTimer> createState() =>
      LinearProgressIndicatorWithTimerState();
}

class LinearProgressIndicatorWithTimerState
    extends State<LinearProgressIndicatorWithTimer> {
  double progressValue = 1.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: widget.timeInMilliseconds),
        (timer) {
      setState(() {
        progressValue -= 0.0055;
        if (progressValue <= 0) {
          timer.cancel();
          progressValue = 0;
          widget.callBack();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progressValue,
      color: accentColor,
    );
  }
}
