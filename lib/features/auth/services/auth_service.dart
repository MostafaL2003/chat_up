// ignore_for_file: avoid_print

import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<void> signUp(UserCredentials credentials) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: credentials.emailaddress,
      password: credentials.password,
    );
  }

  Future<void> logIn(UserCredentials credentials) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: credentials.emailaddress,
      password: credentials.password,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
