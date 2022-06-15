import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/widgets/auth/button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/widgets/auth/input_field.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';

class ForgotPWPage extends StatefulWidget {
  const ForgotPWPage({Key? key}) : super(key: key);

  @override
  _ForgotPWPageState createState() => _ForgotPWPageState();
}

class _ForgotPWPageState extends State<ForgotPWPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
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
                    'Reset Password',
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
                  Button(
                      text: 'RESET PASSWORD', onPressed: () => resetPassword()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetPassword() async {
    bool result = await context.read<AuthenticationService>().resetPassword(
        email: emailController.text.trim().toLowerCase(), context: context);

    if (result) {
      Navigator.pop(context);

      Toast(
          context: context,
          message: 'Email sent successfully',
          type: ToastType.success);
    }
  }
}
