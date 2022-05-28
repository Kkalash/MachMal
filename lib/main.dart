import 'package:flutter_to_do_app/ui/sidenav.dart';

import 'bloc/category_bloc.dart';
import 'ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'package:flutter_to_do_app/authentification/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
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
          home: _getHomePageOrLogin(),
        ));
  }

  Widget _getHomePageOrLogin() {
    final CategoryBloc categoryBloc = CategoryBloc();

    return FirebaseAuth.instance.currentUser != null
        ? Sidenav(categoryBloc)
        : const LoginPage();
  }
}
