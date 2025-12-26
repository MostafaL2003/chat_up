// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:chat_up/features/chat/screens/chats_screen.dart';
import 'package:chat_up/features/profile/models/user_model.dart';
import 'package:chat_up/features/profile/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;
  final ImagePicker picker = ImagePicker();
  bool _isLoading = false;
  final DatabaseService _databaseService = DatabaseService();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
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
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 60.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                "Complete Your Profile",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "Add a photo and a username to get started",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 78,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  CircleAvatar(
                    backgroundImage:
                        (_image == null ? null : FileImage(_image!)),
                    radius: 74,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child:
                        _image == null
                            ? const Icon(Icons.person, size: 80)
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 3,
                        ),
                      ),
                      child: IconButton(
                        onPressed: showImagePickerOptions,
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              MyTextField(
                controller: _usernameController,
                hintText: "Username",
                obscureText: false,
                prefixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                    text: "Save Profile",
                    onTap: () async {
                      if (_image == null ||
                          _usernameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please add a photo and a username"),
                          ),
                        );
                        return;
                      }

                      setState(() => _isLoading = true);

                      try {
                        bool unique = await _databaseService.isUsernameUnique(
                          _usernameController.text.trim(),
                        );

                        if (!unique) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Username already taken!"),
                            ),
                          );
                          return;
                        }

                        final String uid =
                            FirebaseAuth.instance.currentUser!.uid;
                        String downloadUrl = await _databaseService.getImageUrl(
                          _image!,
                          uid,
                        );

                        UserModel newUser = UserModel(
                          uid: uid,
                          username: _usernameController.text.trim(),
                          imageUrl: downloadUrl,
                        );

                        await _databaseService.saveUserInfo(newUser);

                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatScreen(),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
