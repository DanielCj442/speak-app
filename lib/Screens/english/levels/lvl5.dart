import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/models/phrase_game.dart';
import 'package:speak_app/utils/custom_dialog.dart';

class Level5 extends StatefulWidget {
  @override
  _Level5State createState() =>
      _Level5State();
}

class _Level5State
    extends State<Level5> {
  int gameNum = 1;
  int maxNum = 5;
  final PageController _pageController = PageController();
  Box levels = Hive.box("levels");
  

final List<Map<String, dynamic>> _gameData = [
  {
    'spanishSentence': 'El libro está en la mesa.',
    'englishSentence': 'The book is on the table.',
    'timerDuration': 20,
  },
  {
    'spanishSentence': 'El gato está durmiendo en el sofá.',
    'englishSentence': 'The cat is sleeping on the sofa.',
    'timerDuration': 20,
  },
  {
    'spanishSentence': 'Mi padre trabaja en una oficina.',
    'englishSentence': 'My father works in an office.',
    'timerDuration': 15,
  },
  {
    'spanishSentence': 'El cielo es azul y claro hoy.',
    'englishSentence': 'The sky is blue and clear today.',
    'timerDuration': 15,
  },
  {
    'spanishSentence': 'Tengo tres hermanos y dos hermanas.',
    'englishSentence': 'I have three brothers and two sisters.',
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
      levels.put("lvl5", true);

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
