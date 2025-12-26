import 'package:chat_up/features/auth/cubit/auth_cubit.dart';
import 'package:chat_up/features/auth/cubit/auth_state.dart';
import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:chat_up/features/auth/screens/signup_screen.dart';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';
import 'package:chat_up/features/chat/screens/chats_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(height: 160),
                Image.asset("assets/logo.png", height: 160),
                SizedBox(height: 64),
                MyTextField(
                  prefixIcon: Icon(Icons.email_outlined),
                  errorText:
                      (state is AuthError && state.field == "email")
                          ? state.errorMessage
                          : null,
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),
                SizedBox(height: 16),
                MyTextField(
                  prefixIcon: Icon(Icons.lock_outline),
                  errorText:
                      (state is AuthError && state.field == "password")
                          ? state.errorMessage
                          : null,
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(height: 16),
                state is AuthLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                      onTap: () {
                        final user = UserCredentials(
                          emailaddress: emailController.text,
                          password: passwordController.text,
                        );
                        context.read<AuthCubit>().login(user);
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          context.read<AuthCubit>().authReset();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
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
            );
          },
        ),
      ),
    );
  }
}
