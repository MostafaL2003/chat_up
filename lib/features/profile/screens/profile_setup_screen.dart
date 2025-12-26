import 'dart:io';

import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:chat_up/features/chat/screens/chats_screen.dart';
import 'package:chat_up/features/profile/models/user_model.dart';
import 'package:chat_up/features/profile/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  final bool isEditing;
  ProfileSetupScreen({super.key, this.isEditing = false});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _usernameController = TextEditingController();
  String _existingImageUrl = '';
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  final _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      setState(() {
        _usernameController.text = doc.data()?['username'] ?? '';
        _existingImageUrl = doc.data()?['imageUrl'] ?? '';
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void showOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 60.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                widget.isEditing ? "Edit Profile" : "Complete Your Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 78,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  CircleAvatar(
                    key: UniqueKey(),
                    backgroundImage:
                        _image != null
                            ? FileImage(_image!)
                            : (_existingImageUrl.isNotEmpty
                                    ? NetworkImage(_existingImageUrl)
                                    : null)
                                as ImageProvider?,
                    radius: 74,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child:
                        _image == null && _existingImageUrl.isEmpty
                            ? Icon(Icons.person, size: 80)
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: IconButton(
                        onPressed: showOptions,
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              MyTextField(
                controller: _usernameController,
                hintText: "Username",
                obscureText: false,
                prefixIcon: Icon(Icons.person_outline),
              ),
              SizedBox(height: 32),
              _isLoading
                  ? CircularProgressIndicator()
                  : MyButton(
                    text: "Save Profile",
                    onTap: () async {
                      final name = _usernameController.text.trim();
                      if (name.isEmpty) return;

                      setState(() => _isLoading = true);

                      try {
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                        String downloadUrl = _existingImageUrl;

                        if (_image != null) {
                          downloadUrl = await _databaseService.getImageUrl(
                            _image!,
                            uid,
                          );
                        }

                        UserModel updatedUser = UserModel(
                          uid: uid,
                          username: name,
                          imageUrl: downloadUrl,
                        );

                        await _databaseService.saveUserInfo(updatedUser);

                        if (mounted) {
                          if (widget.isEditing) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        setState(() => _isLoading = false);
                      }
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
