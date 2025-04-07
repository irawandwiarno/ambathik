import 'package:flutter/material.dart';

class AppTextStyles {
  /// 🔹 Headline Styles size 32
  static TextStyle headline1({Color color = Colors.black}) => TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: color,
  );

  /// 🔹 Headline Styles size 24
  static TextStyle headline2({Color color = Colors.black}) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
  );

  /// 🔹 Body Text Styles size 16
  static TextStyle bodyText1({Color color = Colors.black87}) => TextStyle(
    fontSize: 16,
    // fontWeight: FontWeight.normal,
    color: color,
  );
/// body text size 14
  static TextStyle bodyText2({Color color = Colors.black54}) => TextStyle(
    fontSize: 14,
    // fontWeight: FontWeight.normal,
    color: color,
  );

  /// 🔹 Subtitle Styles size 18
  static TextStyle subtitle1({Color color = Colors.grey}) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: color,
  );

  /// 🔹 Button Text Style size 16
  static TextStyle buttonText({Color color = Colors.white}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: color,
  );

  // 🔹 Custom Style
  static TextStyle custom({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
    );
  }
}
