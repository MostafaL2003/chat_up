import 'package:chat_up/features/auth/screens/signup_screen.dart';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
            MyTextField(hintText: "Email", obscureText: false),
            SizedBox(height: 16),
            MyTextField(hintText: "Password", obscureText: true),
            SizedBox(height: 16),
            MyButton(onTap: () {}, text: "Login"),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
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
