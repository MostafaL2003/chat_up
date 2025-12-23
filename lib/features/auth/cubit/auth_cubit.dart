import 'package:chat_up/features/auth/cubit/auth_state.dart';
import 'package:chat_up/features/auth/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInit());

  Future<void> login(dynamic credentials) async {
    emit(AuthLoading());
    try {
      await AuthService().logIn(credentials);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      // 1. Handle Email errors
      if (e.code == 'invalid-email' || e.code == 'user-not-found') {
        emit(
          AuthError(errorMessage: "Check your email address", field: "email"),
        );
      }
      // 2. Handle Password/General Credential errors
      else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        emit(AuthError(errorMessage: "Incorrect password", field: "password"));
      }
      // 3. Catch-all for the rest (Network, Too many attempts, etc.)
      else {
        emit(
          AuthError(
            errorMessage: e.message ?? "Authentication failed",
            field: '',
          ),
        );
      }
    } catch (e) {
      // Safety net for non-Firebase errors
      emit(AuthError(errorMessage: "An unexpected error occurred", field: ''));
    }
  }

  Future<void> signUp(dynamic credentials) async {
    emit(AuthLoading());
    try {
      await AuthService().signUp(credentials);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(
          AuthError(
            errorMessage: "This email is already registered",
            field: "email",
          ),
        );
      } else if (e.code == 'weak-password') {
        emit(
          AuthError(errorMessage: "Password is too weak", field: "password"),
        );
      } else if (e.code == 'invalid-email') {
        emit(AuthError(errorMessage: "Invalid email format", field: "email"));
      } else {
        emit(AuthError(errorMessage: e.message ?? "Sign up failed", field: ''));
      }
    } catch (e) {
      emit(AuthError(errorMessage: "Something went wrong", field: ''));
    }
  }

  void authReset() {
    emit(AuthInit());
  }
}
