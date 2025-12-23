import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;
  final Icon? prefixIcon;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    this.controller,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        style: Theme.of(context).textTheme.bodyMedium,
        controller: controller,
        obscureText: obscureText,
        autofocus: false,

        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          errorText: errorText,
          labelText: hintText,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
