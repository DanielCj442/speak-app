import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speak_app/utils/database_controller.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(BuildContext context, String username, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Enviar correo de verificación
      await cred.user?.sendEmailVerification();
      
      FirestoreService.addUser(
        email: email,
        username: username,
      );
      
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      if (cred.user != null && !cred.user!.emailVerified) {
        log("Email not verified");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Por favor, verifica tu correo electrónico antes de iniciar sesión.'),
        ));
        await _auth.signOut();
        return null;
      }

      return cred.user;
    } catch (e) {
      log("Wrong email or password");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Usuario o contraseña incorrectos'),
      ));
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Se ha enviado un correo para restablecer la contraseña.'),
      ));
    } catch (e) {
      log("Failed to send password reset email: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al enviar el correo de restablecimiento de contraseña.'),
      ));
    }
  }
}
