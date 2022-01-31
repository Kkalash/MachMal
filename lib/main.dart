import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/ui/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reactive Flutter',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        canvasColor: Colors.transparent
      ),
      //Our only screen/page we have
      home: HomePage(title: 'My Todo List'),
    );
  }
}