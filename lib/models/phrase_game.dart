import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:speak_app/Screens/english/levels/lvl3.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/utils/confirmation_dialog.dart';
import 'package:speak_app/utils/custom_dialog.dart';
import 'package:speak_app/utils/custom_timer.dart';

class SentenceFormationGame extends StatefulWidget {
  final String spanishSentence;
  final String englishSentence;
  final int timerDuration;
  final VoidCallback onComplete;
  final int maxNum;
  final int gameNum;

  SentenceFormationGame({
    required this.spanishSentence,
    required this.englishSentence,
    required this.timerDuration,
    required this.onComplete,
    required this.maxNum,
    required this.gameNum,
  });

  @override
  _SentenceFormationGameState createState() => _SentenceFormationGameState();
}

class _SentenceFormationGameState extends State<SentenceFormationGame> {
  late int _counter;
  late Timer _timer;
  late List<String> words;
  List<String> selectedWords = [];
  bool _timeUp = false;
  late CountDownController _countDownController;

  @override
  void initState() {
    super.initState();
    _counter = widget.timerDuration;
    words = widget.englishSentence.split(' ');
    words.shuffle();
    _startTimer();
    _countDownController = CountDownController();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void refreshGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SentenceFormationGameSequence(),
      ),
    );
  }

  void refreshWords() {
    setState(() {
      selectedWords.clear();
      words = widget.englishSentence.split(' ');
      words.shuffle();
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

  bool checkWinCondition() {
    if (selectedWords.join(' ') == widget.englishSentence) {
      _timer.cancel();
      _countDownController.pause();
      return true;
    } else {
      return false;
    }
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_basic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Traduce la frase',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Image(
                  image: AssetImage('assets/snake.png'),
                  width: 100,
                  height: 100,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.spanishSentence,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 100.0,
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Text(
                selectedWords.join(' '),
                style: TextStyle(
                  fontSize: 20.0,
                  color: checkWinCondition() ? Colors.green : Colors.black,
                  fontWeight:
                      checkWinCondition() ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: Center(
                  child: CustomTimer(
                      timerDuration: widget.timerDuration,
                      onComplete: _timeIsUp,
                      countDownController: _countDownController)),
            ),
            const SizedBox(height: 30.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: words.map((word) {
                return ElevatedButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(110, 50),
                    backgroundColor: Colors.black38,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedWords.add(word);
                      words.remove(word);
                    });
                  },
                  child:
                      Text(word, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 30.0),
            if (!checkWinCondition())
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.white,
                onPressed: refreshWords,
                iconSize: 40,
              ),
            const SizedBox(height: 20.0),
            if (checkWinCondition() || _timeUp)
              Center(
                child: IconButton(
                  onPressed: _timeUp ? refreshGame : widget.onComplete,
                  icon: _timeUp
                      ? const Icon(Icons.restart_alt)
                      : const Icon(Icons.navigate_next),
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
