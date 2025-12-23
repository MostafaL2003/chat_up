// ignore_for_file: avoid_print

import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signUp(UserCredentials credentials) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: credentials.emailaddress,
            password: credentials.password,
          );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> logIn(UserCredentials credentials) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: credentials.emailaddress,
        password: credentials.password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
