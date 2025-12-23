import 'package:chat_up/features/auth/cubit/auth_cubit.dart';
import 'package:chat_up/features/auth/cubit/auth_state.dart';
import 'package:chat_up/features/auth/models/user_credentials.dart';
import 'package:chat_up/features/auth/screens/login_screen.dart';
import 'package:chat_up/features/auth/widgets/my_button.dart';
import 'package:chat_up/features/auth/widgets/my_text_field.dart';

import 'package:chat_up/features/profile/screens/profile_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileSetupScreen()),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
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
                  MyTextField(
                    prefixIcon: Icon(Icons.lock_reset_rounded),
                    errorText:
                        (state is AuthError && state.field == "password")
                            ? state.errorMessage
                            : null,
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: confirmPasswordController,
                  ),
                  SizedBox(height: 16),
                  state is AuthLoading
                      ? CircularProgressIndicator()
                      : MyButton(
                        onTap: () {
                          if (passwordController.text ==
                              confirmPasswordController.text) {
                            final user = UserCredentials(
                              emailaddress: emailController.text,
                              password: passwordController.text,
                            );
                            context.read<AuthCubit>().signUp(user);
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
                          style: Theme.of(context).textTheme.bodySmall,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
