import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_to_do_app/ui/login_page.dart';
import 'package:flutter_to_do_app/widgets/toast.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/shared/enums/toast_type.enum.dart';

class SignOut extends StatelessWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Transform.translate(
          offset: const Offset(-25, 0),
          child: const Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 20.5,
              fontFamily: fontFamilyRaleway,
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
          ),
        ),
        onTap: () async {
          var singOut = await context
              .read<AuthenticationService>()
              .signOut(context: context);

          if (singOut) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));

            Toast(
                context: context,
                message: 'Sign Out Successfully',
                type: ToastType.success);
          }
        });
  }
}
