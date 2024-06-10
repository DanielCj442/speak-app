import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speak_app/utils/feedback_dialog.dart';
import 'package:speak_app/utils/theme_notifier.dart';
import 'dart:io';
import 'login_screen.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _username = '';
  String _email = '';
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _darkMode = Hive.box('settings').get('isDarkMode', defaultValue: false);
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _email = user.email ?? '';
      });

      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: _email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _username = querySnapshot.docs.first['username'];
            _photoUrl = querySnapshot.docs.first['image'];
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String filePath = 'user_photos/${_email}.png';
        UploadTask uploadTask =
            _storage.ref().child(filePath).putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await _firestore.collection('users').doc(_email).update({
          'image': downloadUrl,
        });

        setState(() {
          _photoUrl = downloadUrl;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showFeedBackDialog() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => FeedbackDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
        leading: Icon(Icons.tune, color: Theme.of(context).primaryColor),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_basic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Card(
              color: Theme.of(context).cardColor,
              elevation: 5,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _photoUrl.startsWith('http')
                          ? NetworkImage(_photoUrl)
                          : AssetImage(_photoUrl) as ImageProvider,
                    ),
                    SizedBox(width: 16),
                    Text(
                      _username,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Card(
                    color: Theme.of(context).cardColor,
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.photo, color: Theme.of(context).primaryColor),
                      title: Text('Subir nueva foto', style: Theme.of(context).textTheme.bodyLarge),
                      trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                      onTap: () {
                        _pickImage();
                      },
                    ),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.dark_mode, color: Theme.of(context).primaryColor),
                      title: Text('Modo oscuro', style: Theme.of(context).textTheme.bodyLarge),
                      trailing: Consumer<ThemeNotifier>(
                        builder: (context, themeNotifier, child) {
                          return Switch(
                            activeColor: Colors.blueGrey,
                            value: themeNotifier.isDarkMode,
                            onChanged: (bool value) {
                              themeNotifier.toggleTheme(value);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: Theme.of(context).cardColor,
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.feedback, color: Theme.of(context).primaryColor),
                      title: Text('Dejar feedback', style: Theme.of(context).textTheme.bodyLarge),
                      trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                      onTap: () {
                        _showFeedBackDialog();
                      },
                    ),
                  ),
                  // Card(
                  //   color: Theme.of(context).cardColor,
                  //   elevation: 1,
                  //   child: ListTile(
                  //     leading: Icon(Icons.question_answer, color: Theme.of(context).primaryColor),
                  //     title: Text('Preguntas frequentes', style: Theme.of(context).textTheme.bodyLarge),
                  //     trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                  //     onTap: () {
                  //       // Navigate to about screen
                  //     },
                  //   ),
                  // ),
                  Card(
                    color: Theme.of(context).cardColor,
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
                      title: Text('Cerrar sesión', style: Theme.of(context).textTheme.bodyLarge),
                      trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
