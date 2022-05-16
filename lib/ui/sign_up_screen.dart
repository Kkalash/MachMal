import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/bloc/category_bloc.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:provider/provider.dart';
import '../authentification/auth.dart';
import 'sidenav.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final CategoryBloc categoryBloc = CategoryBloc();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  static const labelTextStyle = TextStyle(
    color: tertiaryColor,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );

  final boxDecorationStyle = BoxDecoration(
    color: tertiaryColor,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _buildEmailTF() {
    const textStyle = TextStyle(color: primaryAccentColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: labelTextStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              style: textStyle,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: Icon(Icons.email, color: primaryAccentColor),
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(
                    color: shadeColor,
                  ))),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: labelTextStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            decoration: boxDecorationStyle,
            height: 60.0,
            child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.lock, color: primaryAccentColor),
                    hintText: 'Enter your Password',
                    hintStyle: TextStyle(color: shadeColor)))),
      ],
    );
  }

  Widget _buildSignUpBtn() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        elevation: 5.0,
        padding: const EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        primary: tertiaryColor);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: style,
        onPressed: () {
          context.read<AuthenticationService>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
        },
        child: const Text(
          'SIGN UP',
          style: TextStyle(
            color: primaryAccentColor,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
                  _buildEmailTF(),
                  const SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  _buildSignUpBtn()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
