import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/models/drag_game.dart';
import 'package:speak_app/utils/custom_dialog.dart';

class DraggableMatchingGameSequence extends StatefulWidget {
  @override
  _DraggableMatchingGameSequenceState createState() =>
      _DraggableMatchingGameSequenceState();
}

class _DraggableMatchingGameSequenceState
    extends State<DraggableMatchingGameSequence> {
  int gameNum = 1;
  int maxNum = 5;
  final PageController _pageController = PageController();
  Box levels = Hive.box("levels");

  final List<Map<String, dynamic>> _gameData = [
    {
      'words': ["Prima", "Hija", "Abuela", "Tío", "Padre"],
      'translations': ["Cousin", "Daughter", "Grandmother", "Uncle", "Father"],
      'timerDuration': 20,
    },
    {
      'words': ["Cat", "Dog", "Bird", "Fish", "Horse"],
      'translations': ["Gato", "Perro", "Pájaro", "Pez", "Caballo"],
      'timerDuration': 20,
    },
    {
      'words': ["Red", "Blue", "Green", "Yellow", "Purple"],
      'translations': ["Rojo", "Azul", "Verde", "Amarillo", "Morado"],
      'timerDuration': 20,
    },
    {
      'words': ["Casa", "Cielo", "Mujer", "Escuela", "Libro"],
      'translations': ["House", "Sky", "Woman", "School", "Book"],
      'timerDuration': 20,
    },
    {
      'words': ["Study", "Buy", "Eat", "Work", "Like"],
      'translations': ["Estudiar", "Comprar", "Comer", "Trabajar", "Gustar"],
      'timerDuration': 20,
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
      levels.put("lvl2", true);
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
          return DraggableMatchingGame(
            words: game['words'],
            translations: game['translations'],
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
