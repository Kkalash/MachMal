import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/enums/toast_type.enum.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';

class ForgotPWPage extends StatefulWidget {
  const ForgotPWPage({Key? key}) : super(key: key);

  @override
  _ForgotPWPageState createState() => _ForgotPWPageState();
}

class _ForgotPWPageState extends State<ForgotPWPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

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
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                  _buildEmailTF(),
                  _buildResetPWBtn()
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
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(
                    color: shadeColor,
                  ))),
        ),
      ],
    );
  }

  Widget _buildResetPWBtn() {
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
          bool result = await context
              .read<AuthenticationService>()
              .resetPassword(
                  email: emailController.text.trim().toLowerCase(),
                  context: context);
          if (result) {
            Navigator.pop(context);

            Toast(
                context: context,
                message: 'Email sent successfully',
                type: ToastType.success);
          }
        },
        child: const Text(
          'RESET PASSWORD',
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
}
