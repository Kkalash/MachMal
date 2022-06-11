import 'package:flutter_to_do_app/widgets/auth/button.dart';

import '../authentification/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/auth/input_field.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  primaryColor,
                  primaryColor,
                  primaryAccentColor,
                  primaryAccentColor
                ],
                    stops: [
                  0.1,
                  0.4,
                  0.7,
                  0.9
                ])),
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      color: tertiaryColor,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  InputField(
                      label: 'Email',
                      hint: 'example@gmail.com',
                      inputController: emailController,
                      isEmail: true,
                      icon: Icons.email),
                  const SizedBox(height: 30.0),
                  InputField(
                      label: 'Password',
                      hint: 'Enter your Password',
                      inputController: passwordController,
                      isPassword: true,
                      icon: Icons.lock),
                  const SizedBox(height: 30.0),
                  InputField(
                      label: 'Confirm Password',
                      hint: 'Enter your Password',
                      inputController: confirmPasswordController,
                      isPassword: true,
                      icon: Icons.lock),
                  Button(text: 'SIGN UP', onPressed: () => signup())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signup() async {
    if (passwordController.text != confirmPasswordController.text) {
      Toast(
          context: context,
          message: 'Passwords do not match',
          type: ToastType.error);
      return;
    }

    User? user = await context.read<AuthenticationService>().signUp(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
        context: context);

    if (user != null) {
      await context
          .read<AuthenticationService>()
          .sendVerificationEmail(context: context);
      Navigator.pop(context);

      Toast(
          context: context,
          message: 'Verification email sent. Please check your email.',
          type: ToastType.info);
    }
  }
}
