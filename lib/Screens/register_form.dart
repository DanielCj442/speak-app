import 'package:flutter/material.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/Screens/language_selector_screen.dart';
import 'package:speak_app/Screens/login_screen.dart';
import 'dart:developer';
import 'package:speak_app/auth/auth_service.dart';

import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/fondo_basic.jpg'),
                fit: BoxFit
                    .cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Introduzca sus datos.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30.0),
                      TextFormField(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Nombre de usuario',
                              labelStyle: TextStyle(color: Colors.black)),
                          controller: _name),
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            labelText: 'Correo Electrónico',
                            labelStyle: TextStyle(color: Colors.black)),
                        controller: _email,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(color: Colors.black)),
                        controller: _password,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _signup,
                        child: const Text('Confirmar',
                            style: TextStyle(color: Colors.blueGrey)),
                      ),
                      const SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Ya tengo una cuenta. "),
                            InkWell(
                              onTap: () => goToLogin(context),
                              child: const Text("Iniciar sesión",
                                  style: TextStyle(color: Colors.red)),
                            )
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(context,
        _name.text, _email.text, _password.text);
    if (user != null) {
      log("Usuario creado correctamente");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Revise su correo para verificar su identidad'),
      ));
      goToHome(context);
    }
  }
}
