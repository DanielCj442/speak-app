import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:speak_app/Screens/english/levels/lvl1.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/utils/confirmation_dialog.dart';
import 'package:speak_app/utils/custom_timer.dart';

class LanguageLearningGame extends StatefulWidget {
  final String imagePath;
  final List<String> options;
  final int correctOptionIndex;
  final int timerDuration;
  final VoidCallback onComplete;
  final int maxNum;
  final int gameNum;

  LanguageLearningGame({
    required this.imagePath,
    required this.options,
    required this.correctOptionIndex,
    required this.onComplete,
    this.timerDuration = 15,
    required this.maxNum,
    required this.gameNum,
  });

  @override
  _LanguageLearningGameState createState() => _LanguageLearningGameState();
}

class _LanguageLearningGameState extends State<LanguageLearningGame> {
  late int _counter;
  late Timer _timer;
  bool _timeUp = false;
  bool _pressedCorrectButton = false;
  List<bool> _pressedButtons = [false, false, false, false];
  int _fails = 0;
  late CountDownController _countDownController;

  @override
  void initState() {
    super.initState();
    _counter = widget.timerDuration;
    _startTimer();
    _countDownController = CountDownController();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel();
        setState(() {
          _timeUp = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _timeIsUp() {
    setState(() {
      _timeUp = true;
    });
  }

  bool gameFailed() {
    return _fails == 3;
  }

  void handleOptionPress(int index) {
    if (gameFailed() || _timeUp) return;

    setState(() {
      _pressedButtons[index] = true;
      if (index == widget.correctOptionIndex) {
        _pressedCorrectButton = true;
        _timer.cancel();
        _countDownController.pause();
      } else {
        _fails++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (widget.gameNum - 1) / widget.maxNum;
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey,
          color: Colors.green,
          minHeight: 10,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmationDialog(parentContext: context);
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/fondo_basic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  'Selecciona la opción correcta',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                color: Colors.black45,
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Image.asset(
                        widget.imagePath,
                        width: 300.0,
                        height: 200.0,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 10.0),
                      if (_pressedCorrectButton || _timeUp)
                        Text(
                          widget.options[widget.correctOptionIndex],
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: _timeUp ? Colors.red : Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                  child: CustomTimer(
                      timerDuration: widget.timerDuration,
                      onComplete: _timeIsUp,
                      countDownController: _countDownController)),
              SizedBox(height: 20.0),
              Center(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  alignment: WrapAlignment.center,
                  children: List.generate(widget.options.length, (index) {
                    return SizedBox(
                      width: 150,
                      height: 70,
                      child: TextButton(
                        onPressed: () => handleOptionPress(index),
                        style: TextButton.styleFrom(
                          backgroundColor: _pressedButtons[index] ||
                                  _pressedCorrectButton ||
                                  _timeUp ||
                                  gameFailed()
                              ? (index == widget.correctOptionIndex
                                  ? Colors.green
                                  : Colors.red)
                              : Colors.black38,
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          widget.options[index],
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.0),
              if (_pressedCorrectButton || gameFailed() || _timeUp)
                Center(
                  child: IconButton(
                    onPressed: () {
                      if (_pressedCorrectButton) {
                        widget
                            .onComplete(); 
                      } else if (gameFailed() || _timeUp) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguageLearningSequence()),
                        );
                      }
                    },
                    icon: Icon(
                      _pressedCorrectButton
                          ? Icons.navigate_next
                          : Icons.restart_alt,
                      color: Colors.white,
                    ),
                    iconSize: 50,
                    padding: EdgeInsets.fromLTRB(30, 8, 30, 10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
