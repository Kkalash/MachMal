import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/ui/login_page.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(
          Icons.login,
          color: primaryColor,
        ),
        title: Transform.translate(
          offset: const Offset(-25, 0),
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 20.5,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        onTap: () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage())));
  }
}
