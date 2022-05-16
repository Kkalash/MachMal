import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/bloc/category_bloc.dart';
import 'package:flutter_to_do_app/ui/sign_up_screen.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'forgot_pw_screen.dart';
import 'sidenav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  bool? _rememberMe = false;

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

  Widget _buildForgotPwBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ForgotPWScreen())),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget _buildRememberMe() {
    return SizedBox(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: _rememberMe,
                checkColor: primaryColor,
                activeColor: tertiaryColor,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
              )),
          const Text('Remember me',
              style:
                  TextStyle(color: tertiaryColor, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
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
          Future<bool> test = context.read<AuthenticationService>().logIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
          if (test.asStream() == true) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Sidenav(categoryBloc)));
          }
        },
        child: const Text(
          'LOGIN',
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

  Widget _buildSignupBtn() {
    return GestureDetector(
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpScreen())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrText() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const Text(
        'Or',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildForwardWithoutLoginBtn() {
    return Container(
        alignment: Alignment.topCenter,
        child: TextButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Sidenav(categoryBloc))),
          child: const Text(
            'Continue without Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
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
                    'Sign in',
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
                  _buildForgotPwBtn(),
                  _buildRememberMe(),
                  _buildLoginBtn(),
                  _buildSignupBtn(),
                  _buildOrText(),
                  _buildForwardWithoutLoginBtn(),
                  // Scaffold(
                  //   body: StreamBuilder<User?>(
                  //     stream: FirebaseAuth.instance.authStateChanges(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return Sidenav(categoryBloc);
                  //       } else {
                  //         return const LoginScreen();
                  //       }
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
