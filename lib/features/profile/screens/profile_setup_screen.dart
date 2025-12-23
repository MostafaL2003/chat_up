import 'dart:io';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();

  // FIXED: Now uses the 'source' variable instead of hardcoded gallery
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
      // ADDED: SingleChildScrollView prevents the keyboard from blocking your view
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 60.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                "Complete Your Profile",
                style: Theme.of(context).textTheme.bodyLarge,
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
                    radius: 148,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  CircleAvatar(
                    backgroundImage:
                        (_image == null ? null : FileImage(_image!)),
                    radius: 140,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child:
                        _image == null
                            ? const Icon(Icons.person, size: 150)
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
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: showImagePickerOptions,
                        icon: Icon(
                          Icons.camera_alt_rounded,
                          size:
                              40, // Slightly smaller size looks better inside the container
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const MyTextField(
                hintText: "Username",
                obscureText: false,
                prefixIcon: Icon(
                  Icons.person_outline,
                ), // FIXED: Passed as IconData
              ),
              const SizedBox(height: 16),
              MyButton(onTap: () {}, text: "Save profile"),
            ],
          ),
        ),
      ),
    );
  }
}
