import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/models/selection_game.dart';
import 'package:speak_app/utils/custom_dialog.dart';

class LanguageLearningSequence extends StatefulWidget {
  @override
  _LanguageLearningSequenceState createState() =>
      _LanguageLearningSequenceState();
}

class _LanguageLearningSequenceState extends State<LanguageLearningSequence> {
  int gameNum = 1;
  int maxNum = 5;
  final PageController _pageController = PageController();
   Box levels = Hive.box("levels");

  final List<Map<String, dynamic>> _gameData = [
    {
      'imagePath': 'assets/pan.jpg',
      'options': ['Pant', 'Bread', 'Pain', 'Bake'],
      'correctOptionIndex': 1,
      'timerDuration': 10,
    },
    {
      'imagePath': 'assets/hombre.jpg',
      'options': ['Hammer', 'Orange', 'Man', 'Grape'],
      'correctOptionIndex': 2,
      'timerDuration': 10,
    },
    {
      'imagePath': 'assets/cat.jpg',
      'options': ['Cat', 'Dog', 'Bird', 'Fish'],
      'correctOptionIndex': 0,
      'timerDuration': 10,
    },
    {
      'imagePath': 'assets/yellow.jpg',
      'options': ['Red', 'Blue', 'Green', 'Yellow'],
      'correctOptionIndex': 3,
      'timerDuration': 10,
    },
    {
      'imagePath': 'assets/siblings.jpg',
      'options': ['Parents', 'Brothers', 'Siblings', 'Uncles'],
      'correctOptionIndex': 2,
      'timerDuration': 10,
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
      levels.put("lvl1", true);
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
          return LanguageLearningGame(
            imagePath: game['imagePath'],
            options: game['options'],
            correctOptionIndex: game['correctOptionIndex'],
            timerDuration: game['timerDuration'],
            onComplete:
                _onGameComplete,
            gameNum: gameNum,
            maxNum: maxNum,
          );
        },
      ),
    );
  }
}
