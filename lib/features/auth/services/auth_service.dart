// ignore_for_file: avoid_print

import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:chat_up/features/profile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<UserCredential> signUp(UserCredentials credentials) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: credentials.emailaddress,
          password: credentials.password,
        );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
          'uid': userCredential.user!.uid,
          'username': 'User',
          'imageUrl': '',
        });

    return userCredential;
  }

  Future<UserCredential> logIn(UserCredentials credentials) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: credentials.emailaddress,
      password: credentials.password,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserModel> getUserData(String uid) async {
  try {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
 
      return UserModel(
        username: doc['username'], 
        imageUrl: doc['imageUrl'], 
        uid: uid,
      );
    } else {
      throw "User document does not exist in Firestore";
    }
  } catch (e) {
    throw "Error fetching user data: $e";
  }
}
}
