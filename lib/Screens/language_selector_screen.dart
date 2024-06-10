import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {

//Implementar cuando haya varios idiomas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo_basic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '¿Qué idioma te gustaría aprender?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
            
                },
                child: Text('Inglés'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  
                },
                child: Text('Alemán'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
