import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.5,
            fontFamily: fontFamilyRaleway,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: () {});
  }
}
