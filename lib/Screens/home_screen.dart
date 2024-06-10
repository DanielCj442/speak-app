import 'package:flutter/material.dart';
import 'package:speak_app/Screens/english/english_dictionary.dart';
import 'package:speak_app/Screens/login_screen.dart';
import 'package:speak_app/Screens/serpent_screen.dart';
import 'package:speak_app/Screens/settings_screen.dart';
import 'package:speak_app/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  

  final List<Widget> _screens = [
    SerpentScreen(), 
    DictionaryScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Theme.of(context).primaryColor,
        
       
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book), 
            label: 'Diccionario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Perfil',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}