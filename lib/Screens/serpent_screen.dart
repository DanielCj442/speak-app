import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:speak_app/Screens/english/levels/lvl1.dart';
import 'package:speak_app/Screens/english/levels/lvl2.dart';
import 'package:speak_app/Screens/english/levels/lvl3.dart';
import 'package:speak_app/Screens/english/levels/lvl4.dart';
import 'package:speak_app/Screens/english/levels/lvl5.dart';
import 'package:speak_app/utils/theme_notifier.dart';

class SerpentScreen extends StatefulWidget {
  @override
  _SerpentScreenState createState() => _SerpentScreenState();
}

class _SerpentScreenState extends State<SerpentScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late List<bool> completedList = [
    Hive.box('levels').get('lvl1', defaultValue: false),
    Hive.box('levels').get('lvl2', defaultValue: false),
    Hive.box('levels').get('lvl3', defaultValue: false),
    Hive.box('levels').get('lvl4', defaultValue: false),
    Hive.box('levels').get('lvl5', defaultValue: false),
  ];
  late int eggs = 0;

  int _levelsCompleted() {
    eggs = 0;
    for (bool lvlCompleted in completedList) {
      if (lvlCompleted) {
        eggs++;
      }
    }
    return eggs;
  }

  @override
  Widget build(BuildContext context) {
    bool lvl1Completed = Hive.box('levels').get('lvl1', defaultValue: false);
    bool lvl2Completed = Hive.box('levels').get('lvl2', defaultValue: false);
    bool lvl3Completed = Hive.box('levels').get('lvl3', defaultValue: false);
    bool lvl4Completed = Hive.box('levels').get('lvl4', defaultValue: false);
    bool lvl5Completed = Hive.box('levels').get('lvl5', defaultValue: false);

    User? user = _auth.currentUser;
    var theme = Theme.of(context);
    var isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: [
                Text(_levelsCompleted().toString(),
                    style: Theme.of(context).textTheme.bodyLarge),
                Icon(Icons.egg_outlined, color: theme.primaryColor)
              ],
            ),
          )
        ],
        title: user != null
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }

                  if (snapshot.hasError) {
                    return Text('Error');
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('User not found');
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  String username = userData['username'] ?? 'User';
                  String photoUrl =
                      userData['image'] ?? 'assets/sample_user.png';

                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: photoUrl.startsWith('http')
                            ? NetworkImage(photoUrl)
                            : AssetImage(photoUrl) as ImageProvider,
                      ),
                      SizedBox(width: 10),
                      Text(username,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  );
                },
              )
            : Text('User not found'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/fondo_snake.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  SerpentButton1(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguageLearningSequence()),
                    );
                  }),
                  SerpentButton2(onPressed: () {
                    if (lvl1Completed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DraggableMatchingGameSequence()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Completa el nivel anterior antes de continuar.'),
                      ));
                    }
                  }),
                  SerpentButton3(onPressed: () {
                    if (lvl2Completed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SentenceFormationGameSequence()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Completa el nivel anterior antes de continuar.'),
                      ));
                    }
                  }),
                  SerpentButton4(onPressed: () {
                    if (lvl3Completed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Level4()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Completa el nivel anterior antes de continuar.'),
                      ));
                    }
                  }),
                  SerpentButton5(onPressed: () {
                    if (lvl4Completed) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Level5()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Completa el nivel anterior antes de continuar.'),
                      ));
                    }
                  }),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SerpentButton1 extends StatelessWidget {
  final VoidCallback onPressed;

  const SerpentButton1({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lvl1Completed = Hive.box('levels').get('lvl1', defaultValue: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: lvl1Completed ? Colors.green : Colors.grey,
            onPressed: onPressed,
            child: Text('1', style: TextStyle(fontSize: 20)),
            mini: false,
            heroTag: 'level_1',
          ),
        ],
      ),
    );
  }
}

class SerpentButton2 extends StatelessWidget {
  final VoidCallback onPressed;

  const SerpentButton2({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lvl2Completed = Hive.box('levels').get('lvl2', defaultValue: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: lvl2Completed ? Colors.green : Colors.grey,
            onPressed: onPressed,
            child: Text('2', style: TextStyle(fontSize: 20)),
            mini: false,
            heroTag: 'level_2',
          ),
        ],
      ),
    );
  }
}

class SerpentButton3 extends StatelessWidget {
  final VoidCallback onPressed;

  const SerpentButton3({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lvl3Completed = Hive.box('levels').get('lvl3', defaultValue: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: lvl3Completed ? Colors.green : Colors.grey,
            onPressed: onPressed,
            child: Text('3', style: TextStyle(fontSize: 20)),
            mini: false,
            heroTag: 'level_3',
          ),
        ],
      ),
    );
  }
}

class SerpentButton4 extends StatelessWidget {
  final VoidCallback onPressed;

  const SerpentButton4({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lvl4Completed = Hive.box('levels').get('lvl4', defaultValue: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: lvl4Completed ? Colors.green:Colors.grey,
            onPressed: onPressed,
            child: Text('4', style: TextStyle(fontSize: 20)),
            mini: false,
            heroTag: 'level_4',
          ),
        ],
      ),
    );
  }
}

class SerpentButton5 extends StatelessWidget {
  final VoidCallback onPressed;

  const SerpentButton5({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool lvl5Completed = Hive.box('levels').get('lvl5', defaultValue: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            backgroundColor: lvl5Completed ? Colors.green : Colors.grey,
            onPressed: onPressed,
            child: Text('5', style: TextStyle(fontSize: 20)),
            mini: false,
            heroTag: 'level_5',
          ),
        ],
      ),
    );
  }
}
