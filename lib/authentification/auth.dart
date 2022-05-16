import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../bloc/category_bloc.dart';
import '../ui/sidenav.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:common_utils/common_utils.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);
  final CategoryBloc categoryBloc = CategoryBloc();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> logIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<String> signUp(
      {required String email, required String password}) async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //         ));
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
//TODO Auf Sidenav navigieren??
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

//   Future<Void> signOut() async {
//     await _firebaseAuth.signOut();
//   }

  Future resetPassword(TextEditingController emailController) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
