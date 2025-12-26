import 'package:chat_up/features/auth/cubit/auth_state.dart';
import 'package:chat_up/features/auth/screens/login_screen.dart';
import 'package:chat_up/features/auth/services/auth_service.dart';
import 'package:chat_up/features/profile/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInit());

  // Added this so the app knows the user data changed
  void updateUser(UserModel user) {
    emit(AuthSuccess(userModel: user));
  }

  Future<void> login(dynamic credentials) async {
    emit(AuthLoading());
    try {
      UserCredential userCred = await AuthService().logIn(credentials);
      UserModel user = await AuthService().getUserData(userCred.user!.uid);
      emit(AuthSuccess(userModel: user));
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      emit(AuthError(errorMessage: e.toString(), field: ''));
    }
  }

  Future<void> signUp(dynamic credentials) async {
    emit(AuthLoading());
    try {
      UserCredential userCred = await AuthService().signUp(credentials);
      UserModel user = await AuthService().getUserData(userCred.user!.uid);
      emit(AuthSuccess(userModel: user));
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      emit(AuthError(errorMessage: e.toString(), field: ''));
    }
  }

  void _handleFirebaseError(FirebaseAuthException e) {
    if (e.code == 'invalid-email' ||
        e.code == 'user-not-found' ||
        e.code == 'email-already-in-use') {
      emit(AuthError(errorMessage: e.message ?? "Email error", field: "email"));
    } else if (e.code == 'wrong-password' ||
        e.code == 'invalid-credential' ||
        e.code == 'weak-password') {
      emit(
        AuthError(
          errorMessage: e.message ?? "Password error",
          field: "password",
        ),
      );
    } else {
      emit(
        AuthError(
          errorMessage: e.message ?? "Authentication failed",
          field: '',
        ),
      );
    }
  }

  void authReset() {
    emit(AuthInit());
  }

  Future<void> logOut(BuildContext context) async {
    emit(AuthLoading());
    try {
      await AuthService().signOut();
      emit(AuthInit());
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (e) {
      emit(AuthError(errorMessage: e.toString(), field: ''));
    }
  }
}
