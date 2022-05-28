import 'sidenav.dart';
import 'forgot_pw_page.dart';
import 'package:hive/hive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/ui/sign_up_page.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/enums/toast_type.enum.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key})  : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  

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

  static const labelTextStyle = TextStyle(
    color: tertiaryColor,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );

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
                  _buildEmailTF(),
                  const SizedBox(height: 30.0),
                  _buildPasswordTF(),
                  _buildForgotPwBtn(),
                  _buildRememberMe(),
                  _buildLoginBtn(),
                  _buildSignupBtn(),
                  _buildOrText(),
                  _buildForwardWithoutLoginBtn(),
                ],
              ),
              
            ),
          ),
        ],
      ),
    );
  }

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
                  hintText: 'example@gmail.com',
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
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ForgotPWPage())),
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
                  _rememberMe = !_rememberMe;
                  setState(() {
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
        onPressed: () async {
          User? user = await context.read<AuthenticationService>().login(
              email: emailController.text.trim().toLowerCase(),
              password: passwordController.text.trim()
              context: context);

          if(user != null) {
           rememberUser();
              
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Sidenav()));
                
            Toast(
                context: context,
                message: 'Login Successful',
                type: ToastType.success);
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
          onPressed: () async {
              User? user = await context.read<AuthenticationService>()
              .singInAnonym(context: context);

          if(user != null) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Sidenav()));
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
}
