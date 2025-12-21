import 'package:chat_up/features/auth/screens/login_screen.dart';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/logo.png", height: 160),
              SizedBox(height: 64),
              MyTextField(hintText: "Username", obscureText: false),
              SizedBox(height: 16),
              MyTextField(hintText: "Email", obscureText: false),
              SizedBox(height: 16),
              MyTextField(hintText: "Password", obscureText: true),
              SizedBox(height: 16),
              MyTextField(hintText: "Confirm Password", obscureText: true),
              SizedBox(height: 16),
              MyButton(onTap: () {}, text: "Sign up"),
              SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ?",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login here",
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
      ),
    );
  }
}
