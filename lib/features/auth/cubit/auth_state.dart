sealed class AuthState {}

class AuthInit extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  final String field;

  AuthError({required this.errorMessage,required this.field});
}
