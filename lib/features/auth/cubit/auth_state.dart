import 'package:chat_up/features/profile/models/user_model.dart';

sealed class AuthState {}

class AuthInit extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel userModel; // The Cubit now "carries" the user data
  AuthSuccess({required this.userModel});
}

class AuthError extends AuthState {
  final String errorMessage;
  final String field;

  AuthError({required this.errorMessage,required this.field});
}
