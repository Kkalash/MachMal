import 'sidenav.dart';
import 'forgot_pw_page.dart';
import 'package:hive/hive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/ui/sign_up_page.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/auth/button.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/widgets/auth/input_field.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key})  : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _rememberMe = false;
  late Box box;

  @override
  void initState() {
    super.initState();

    createBox();
  }

  @override
  void dispose() {
    super.dispose();
    
    emailController.dispose();
    passwordController.dispose();
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
                  forgotPwBtn(),
                  rememberMe(),
                  Button(text: 'LOGIN', onPressed: () => login()),
                  signupBtn(),
                  Container(
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
    ),
                  forwardWithoutLoginBtn(),
                ],
              ),
              
            ),
          ),
        ],
      ),
    );
  }

  Widget forgotPwBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ForgotPWPage())),
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget rememberMe() {
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
                onChanged: (value) =>
                  setState(() {
                  _rememberMe = !_rememberMe;
                  })
                ,
              )),
          const Text('Remember me',
              style:
                  TextStyle(color: tertiaryColor, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget signupBtn() {
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
                  fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget forwardWithoutLoginBtn() {
    return Container(
        alignment: Alignment.topCenter,
        child: TextButton(
          onPressed: () async {
              User? user = await context.read<AuthenticationService>()
              .singInAnonym(context: context);

          if(user != null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Sidenav()));
          }
          },
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

  void createBox() async {
    box = await Hive.openBox('logindata');
    getData();
  }

  void getData() async {
    if (box.get('email') != null) {
      emailController.text = box.get('email');
    }

    if (box.get('password') != null) {
      passwordController.text = box.get('password');
    }
  }

  void rememberUser() async {
    if (_rememberMe) {
      box.put('email', emailController.text.trim().toLowerCase());
      box.put('password', passwordController.text);
      } else {
        box.delete('email');
        box.delete('password');
      }
  }

  void login() async {
    User? user = await context.read<AuthenticationService>().login(
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text.trim()
      context: context);

    if(user != null) {
      rememberUser();

      if (user.emailVerified) {    
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Sidenav()));
                
        Toast(
          context: context,
          message: 'Login Successful',
          type: ToastType.success);
        } else {
          Toast(
            context: context,
            message: 'Please verify your email',
            type: ToastType.info);
          }
     }
  }
}
