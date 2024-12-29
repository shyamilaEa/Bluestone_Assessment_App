import 'package:flutter/material.dart';
import 'colors.dart';

const String primaryFontName = 'Manrope';

class TextStyleClass {
  static const double textHeight = 1;

  ///-------------------------300--------------------------------------///

  static TextStyle blackTextStyle(double size) {
    return TextStyle(
        fontFamily: primaryFontName,
        fontWeight: FontWeight.w500,
        color: ColorClass.textBlack,
        height: textHeight,
        fontSize: size);
  }

  static TextStyle blackText(double size) {
    return TextStyle(
        fontFamily: primaryFontName,
        fontWeight: FontWeight.w700,
        color: ColorClass.textBlack,
        height: textHeight,
        fontSize: size);
  }
}