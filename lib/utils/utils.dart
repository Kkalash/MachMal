import 'package:flutter/material.dart';

const Color PRIMARY_COLOR = Color(0xFF5C2018);
const Color PRIMARY_ACCENT_COLOR = Color(0xFFBC4639);
const Color SECONDARY_COLOR = Color(0xFFBC4639);
const Color SHADE_COLOR = Color(0xFFD4A59A);
const Color TERTIARY_COLOR = Color.fromARGB(255, 248, 234, 231);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

final boxDecorationStyle = BoxDecoration(
  color: TERTIARY_COLOR,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final labelTextStyle = TextStyle(
  color: TERTIARY_COLOR,
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
);

final textStyle = TextStyle(color: PRIMARY_ACCENT_COLOR);
