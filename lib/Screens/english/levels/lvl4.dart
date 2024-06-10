import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/models/drag_game.dart';
import 'package:speak_app/utils/custom_dialog.dart';

class Level4 extends StatefulWidget {
  @override
  _Level4State createState() =>
      _Level4State();
}

class _Level4State
    extends State<Level4> {
  int gameNum = 1;
  int maxNum = 4;
  final PageController _pageController = PageController();
  Box levels = Hive.box("levels");

  final List<Map<String, dynamic>> _gameData = [
    {
      'words': ["Puerta", "Hombre", "Coche", "Ventana", "Tienda"],
      'translations': ["Door", "Man", "Car", "Window", "Shop"],
      'timerDuration': 15,
    },
    {
      'words': ["Live", "Look", "To Be", "Write", "Play"],
      'translations': ["Vivir", "Mirar", "Ser", "Escribir", "Jugar"],
      'timerDuration': 15,
    },
    {
      'words': ["Sopa", "Verdura", "Arroz", "Pollo", "Pescado"],
      'translations': ["Soup", "Vegetable", "Rice", "Chicken", "Fish"],
      'timerDuration': 15,
    },
    {
      'words': ["Meat", "Fruit", "Read", "Sleep", "Grandfather"],
      'translations': ["Carne", "Fruta", "Leer", "Dormir", "Abuelo"],
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
      levels.put("lvl4", true);
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
