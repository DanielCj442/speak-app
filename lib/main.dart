import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:speak_app/Screens/login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speak_app/utils/database_controller.dart';
import 'package:speak_app/utils/dictionary_import.dart';
import 'package:speak_app/utils/theme_notifier.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox("levels");
  await Hive.openBox("settings");
  
  // Add words in dictionary (NO USAR DE NUEVO)
  // for (var word in words) {
  //   await FirestoreService.addWord(
  //     word: word['word']!,
  //     translation: word['translation']!,
  //     category: word['category']!,
  //   );
  // }

  bool isDarkMode = Hive.box('settings').get('isDarkMode', defaultValue: false);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(isDarkMode),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Speak',
          theme: ThemeData(
            primaryColor: Colors.black,
            cardColor: Colors.white,
            canvasColor: Colors.blueGrey,
            primaryColorDark: Colors.grey[300],
            primaryColorLight: Colors.grey[100],
            textTheme: const TextTheme(
              headlineSmall: TextStyle(color: Colors.black),
              headlineMedium: TextStyle(color: Colors.black),
              headlineLarge: TextStyle(color: Colors.black),
              bodySmall: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              bodyLarge: TextStyle(color: Colors.black),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            primaryColor: Colors.white,
            cardColor: Colors.black45,
            canvasColor: Colors.blueGrey[900],
            primaryColorDark: Colors.blueGrey[700],
            primaryColorLight: Colors.blueGrey[600],
            textTheme: const TextTheme(
              headlineSmall: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(color: Colors.white),
              bodySmall: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black87,
            ),
          ),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const LoginPage(),
        );
      },
    );
  }
}
