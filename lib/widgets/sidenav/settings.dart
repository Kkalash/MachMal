import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.5,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: () {});
  }
}
