import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';
import 'package:flutter_to_do_app/ui/sign_up_screen.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
              create: (_) => AuthenticationService(FirebaseAuth.instance)),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Reactive Flutter',
          theme: ThemeData(
              primarySwatch: createMaterialColor(const Color(0xFF116466)),
              canvasColor: Colors.transparent),
          home: const LoginScreen(),
        ));
  }

/*   @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return const LoginScreen();
    }
    return const SignUpScreen();
  } */
}
