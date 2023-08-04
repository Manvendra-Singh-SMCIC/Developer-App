import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  final String text;
  final dynamic fontFamily;
  final Color color;
  final FontWeight fontWeight;

  AppText({
    super.key,
    required this.text,
    this.fontFamily = "",
    this.color = Colors.white,
    this.size = 16,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    if (size == 16) {
      size = 16;
    }
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}

class AppTextModified extends StatelessWidget {
  double size;
  final String text;
  final dynamic fontFamily;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign align;

  AppTextModified({
    super.key,
    required this.text,
    this.fontFamily = "",
    this.color = Colors.white,
    this.size = 16,
    this.fontWeight = FontWeight.normal,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    if (size == 16) {
      size = 16;
    }
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }
}
