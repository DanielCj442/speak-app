import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speak_app/Screens/home_screen.dart';
import 'package:speak_app/Screens/language_selector_screen.dart';
import 'package:speak_app/Screens/register_form.dart';
import 'package:speak_app/auth/auth_service.dart';
import 'package:speak_app/auth/reset_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
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
                    'assets/fondo_login.jpg'),
                fit: BoxFit
                    .cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo_speak.png',
                        width:
                            300,
                        height:
                            200,
                      ),
                      Text(
                          'La forma divertida y efectiva de aprender idiomas.', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 30.0),
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
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.blueGrey)),
                      ),
                      SizedBox(height: 8.0),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text("¿No tienes una cuenta? ", style: TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () => goToSignup(context),
                        child:
                            const Text("Regístrate", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                      
                    ]),
                    const SizedBox(height: 16.0),
                      InkWell(
                        onTap: () => goToResetPassword(context),
                        child: const Text("He olvidado mi contraseña", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                      //const SizedBox(height: 15),
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

   goToResetPassword(BuildContext context) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
  );

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterForm()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(context, _email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      goToHome(context);
    }
  }
}
