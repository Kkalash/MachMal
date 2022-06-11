import 'package:flutter/material.dart';
import 'package:flutter_to_do_app/shared/utils/utils.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: const Text(
          'About',
          style: TextStyle(
            fontSize: 20.5,
            fontFamily: fontFamilyRaleway,
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: () {});
  }
}
