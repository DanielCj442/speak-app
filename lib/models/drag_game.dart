import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:speak_app/Screens/english/levels/lvl2.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/utils/confirmation_dialog.dart';
import 'dart:math';

import 'package:speak_app/utils/custom_timer.dart';

class DraggableMatchingGame extends StatefulWidget {
  final List<String> words;
  final List<String> translations;
  final int timerDuration;
  final VoidCallback onComplete;
  final int maxNum;
  final int gameNum;

  DraggableMatchingGame({
    required this.words,
    required this.translations,
    required this.timerDuration,
    required this.onComplete,
    required this.maxNum,
    required this.gameNum,
  });

  @override
  _DraggableMatchingGameState createState() => _DraggableMatchingGameState();
}

class _DraggableMatchingGameState extends State<DraggableMatchingGame> {
  late int _counter;
  late Timer _timer;
  Map<String, String> matchedWords = {};
  Map<String, Color> itemColors = {};
  bool _timeUp = false;
  late List<String> shuffledTranslations;
  late CountDownController _countDownController;

  @override
  void initState() {
    super.initState();
    _counter = widget.timerDuration;
    _startTimer();
    shuffledTranslations = List<String>.from(widget.translations)
      ..shuffle(Random());
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

  void _timeIsUp() {
    setState(() {
      _timeUp = true;
    });
  }

  void refreshGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DraggableMatchingGameSequence(),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool checkWinCondition() {
    if (matchedWords.length == widget.words.length) {
    _countDownController.pause();
    _timer.cancel();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (widget.gameNum -1) / widget.maxNum;
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            Center(
              child: Text(
                'Arrastra hasta la opción correcta',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Center(
                child: CustomTimer(
              timerDuration: widget.timerDuration,
              onComplete: _timeIsUp,
              countDownController: _countDownController,
            )),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.words.length, (index) {
                    return Draggable<String>(
                      data: widget.words[index],
                      child: DraggableItem(
                        text: widget.words[index],
                        color: itemColors[widget.words[index]] ?? Colors.blue,
                      ),
                      feedback: DraggableItem(
                          text: widget.words[index], isDragging: true),
                      childWhenDragging: DraggableItem(
                          text: widget.words[index], isDragging: false),
                    );
                  }),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(shuffledTranslations.length, (index) {
                    return DragTarget<String>(
                      builder: (BuildContext context, List<String?> incoming,
                          List rejected) {
                        return Container(
                          width: 150,
                          height: 70,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              matchedWords[shuffledTranslations[index]] ??
                                  shuffledTranslations[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        );
                      },
                      onWillAccept: (data) => true,
                      onAccept: (data) {
                        setState(() {
                          int originalIndex = widget.translations
                              .indexOf(shuffledTranslations[index]);
                          if (widget.words.indexOf(data) == originalIndex) {
                            itemColors[data] = Colors.green;
                            matchedWords[shuffledTranslations[index]] = data;
                          } else {
                            itemColors[data] = Colors.red;
                          }
                        });
                        checkWinCondition();
                      },
                    );
                  }),
                ),
              ],
            ),
            SizedBox(
                height: 20.0),
            if (checkWinCondition() || _timeUp)
              Center(
                child: IconButton(
                  onPressed: _timeUp ? refreshGame : widget.onComplete,
                  icon: _timeUp
                      ? Icon(Icons.restart_alt)
                      : Icon(Icons.navigate_next),
                  color: Colors.white,
                  iconSize: 50,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DraggableItem extends StatelessWidget {
  final String text;
  final bool isDragging;
  final Color? color;

  DraggableItem({required this.text, this.isDragging = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: isDragging ? Colors.grey : color ?? Colors.blue,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
