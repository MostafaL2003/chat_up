import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:chat_up/features/auth/screens/login_screen.dart';
import 'package:chat_up/features/auth/services/auth_service.dart';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:chat_up/features/chat/screens/chats_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
              MyTextField(
                hintText: "Username",
                obscureText: false,
                controller: userNameController,
              ),
              SizedBox(height: 16),
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
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPasswordController,
              ),
              SizedBox(height: 16),
              MyButton(
                onTap: () async {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
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
                  } else {
                    print("NO LOGIN");
                  }
                },
                text: "Sign up",
              ),
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
                          // ignore: use_build_context_synchronously
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
