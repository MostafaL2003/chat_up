import 'dart:io';
import 'package:chat_up/features/profile/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  Future<String> getImageUrl(File imageFile, String uid) async {
    final cloudinary = CloudinaryPublic(
      'dbs7uksfk',
      'chat_up_preset',
      cache: false,
    );

    CloudinaryResponse response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        imageFile.path,
        folder: 'profile-pics',
      ),
    );

    return response.secureUrl;
  }

  Future<void> saveUserInfo(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<bool> isUsernameUnique(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.trim())
        .get();

    return result.docs.isEmpty;
  }
}