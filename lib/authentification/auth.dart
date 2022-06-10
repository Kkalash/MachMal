import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User?> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;

    if (await isAuthInputValid(email, password, context)) {
      try {
        UserCredential credential = await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);

        user = credential.user;
      } on FirebaseAuthException catch (e) {
        handelError(e, context);

        user = null;
      }
    }

    return user;
  }

  Future<User?> singInAnonym({required BuildContext context}) async {
    User? user;

    try {
      UserCredential credential = await _firebaseAuth.signInAnonymously();

      user = credential.user;
    } on FirebaseAuthException catch (e) {
      handelError(e, context);

      user = null;
    }

    return user;
  }

  Future<User?> signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    User? user;

    if (await isAuthInputValid(email, password, context)) {
      try {
        UserCredential credential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        user = credential.user;
      } on FirebaseAuthException catch (e) {
        handelError(e, context);

        user = null;
      }
    }

    return user;
  }

  Future sendVerificationEmail({required BuildContext context}) async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      handelError(e, context);
    }
  }

  Future<bool> signOut() async {
    bool singedout = false;

    await _firebaseAuth
        .signOut()
        .then((value) => singedout = true)
        .onError((error, stackTrace) => singedout = false);

    return singedout;
  }

  Future<bool> resetPassword(
      {required String email, required BuildContext context}) async {
    bool reseted = false;

    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => reseted = true)
        .onError((error, stackTrace) => reseted = false);

    return reseted;
  }

  void handelError(FirebaseAuthException error, BuildContext context) {
    if (kDebugMode) {
      print(error.message);
    }

    switch (error.code) {
      case 'email-already-in-use':
        Toast(
            context: context,
            message: 'User already exists',
            type: ToastType.error);
        break;
      case 'invalid-email':
        Toast(
            context: context,
            message: 'Please enter a valid email',
            type: ToastType.error);
        break;
      case 'weak-password':
        Toast(
            context: context,
            message: 'Password is too weak',
            type: ToastType.warning);
        break;
      case 'user-not-found':
        Toast(
            context: context,
            message: 'User not exists. Please sign up',
            type: ToastType.error);
        break;
      case 'wrong-password':
        Toast(
            context: context,
            message: 'Wrong password. Please try again',
            type: ToastType.error);
        break;
      case 'too-many-requests':
        Toast(
            context: context,
            message: 'Too many requests. Please try again later',
            type: ToastType.error);
        break;
      default:
        Toast(
            context: context,
            message: 'Something went wrong. Please try again',
            type: ToastType.error);
        break;
    }
  }

  Future<bool> isAuthInputValid(
      String email, String password, BuildContext context) async {
    bool isValid = true;

    if (email.isEmpty) {
      Toast(
          context: context,
          message: 'Please enter your email',
          type: ToastType.info);

      isValid = false;
    }

    if (password.isEmpty) {
      Toast(
          context: context,
          message: 'Please enter a password',
          type: ToastType.info);

      isValid = false;
    }

    return isValid;
  }
}
