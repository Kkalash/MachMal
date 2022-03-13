import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/utils/utils.dart';
import 'ui/login_screen.dart';

void main() => runApp(const ToDoApp());

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reactive Flutter',
      theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF116466)),
          canvasColor: Colors.transparent),
      home: const LoginScreen(),
    );
  }
}
