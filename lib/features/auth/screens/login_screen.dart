import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:chat_up/features/auth/screens/signup_screen.dart';
import 'package:chat_up/features/auth/services/auth_service.dart';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:chat_up/features/chat/screens/chats_screen.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 128),
            Image.asset("assets/logo.png", height: 160),
            SizedBox(height: 64),
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
            ),
            SizedBox(height: 16),
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(height: 16),
            MyButton(
              onTap: () async {
                final user = UserCredentials(
                  emailaddress: emailController.text,
                  password: passwordController.text,
                );
                await AuthService().logIn(user);

                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => ChatsScreen()),
                );
              },
              text: "Login",
            ),
            SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dont have an account ?",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
