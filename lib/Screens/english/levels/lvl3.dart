import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/models/phrase_game.dart';
import 'package:speak_app/utils/custom_dialog.dart';

class SentenceFormationGameSequence extends StatefulWidget {
  @override
  _SentenceFormationGameSequenceState createState() =>
      _SentenceFormationGameSequenceState();
}

class _SentenceFormationGameSequenceState
    extends State<SentenceFormationGameSequence> {
  int gameNum = 1;
  int maxNum = 5;
  final PageController _pageController = PageController();
  Box levels = Hive.box("levels");
  

  final List<Map<String, dynamic>> _gameData = [
    {
      'spanishSentence': 'Hola, ¿cómo estás?',
      'englishSentence': 'Hello, how are you?',
      'timerDuration': 15,
    },
    {
      'spanishSentence': 'Tengo un perro.',
      'englishSentence': 'I have a dog.',
      'timerDuration': 15,
    },
    {
      'spanishSentence': 'Me gusta la pizza.',
      'englishSentence': 'I like pizza.',
      'timerDuration': 15,
    },
    {
      'spanishSentence': 'El cielo es azul.',
      'englishSentence': 'The sky is blue.',
      'timerDuration': 15,
    },
    {
      'spanishSentence': 'Ella está estudiando.',
      'englishSentence': 'She is studying.',
      'timerDuration': 15,
    },
  ];

  void _showCustomAlertDialog() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => CustomAlertDialog(),
      ),
    );
  }

  void _onGameComplete() {
    int currentPage = _pageController.page?.toInt() ?? 0;
    if (currentPage < _gameData.length - 1) {
      gameNum++;
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _showCustomAlertDialog();
      levels.put("lvl3", true);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        physics:
            NeverScrollableScrollPhysics(),
        itemCount: _gameData.length,
        itemBuilder: (context, index) {
          final game = _gameData[index];
          return SentenceFormationGame(
            spanishSentence: game['spanishSentence'],
            englishSentence: game['englishSentence'],
            timerDuration: game['timerDuration'],
            gameNum: gameNum,
            maxNum: maxNum,
            onComplete:
                _onGameComplete,
          );
        },
      ),
    );
  }
}
