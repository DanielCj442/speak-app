import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class CustomTimer extends StatefulWidget {
  final int timerDuration;
  final Function onComplete;
  final CountDownController countDownController;

  CustomTimer({
    required this.timerDuration,
    required this.onComplete,
    required this.countDownController,
  });

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  @override
  Widget build(BuildContext context) {
    return CircularCountDownTimer(
      duration: widget.timerDuration,
      initialDuration: 0,
      controller: widget.countDownController,
      width: 30,
      height: 30,
      ringColor: Colors.blueGrey[300]!,
      ringGradient: null,
      fillColor: Colors.blueGrey[100]!,
      fillGradient: null,
      backgroundColor: Colors.white,
      backgroundGradient: null,
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: const TextStyle(
          fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
      textFormat: CountdownTextFormat.S,
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: true,
      onComplete: () {
        widget.onComplete;
      },
    );
  }
}
