import 'package:flutter/material.dart';

class AppTextStyles {
  static const headline1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: 'SUIT',
  );
  static const headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: 'SUIT',
  );
  static const headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: 'SUIT',
  );
  static const headline4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: 'SUIT',
  );
  static const headline5 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'SUIT',
  );
  static const subTitle1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'SUIT',
  );
  static const subTitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'SUIT',
  );
  static const subTitle3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'SUIT',
  );
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'SUIT',
  );
  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'SUIT',
  );
  static const body3 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'SUIT',
  );
  static const caption1 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    fontFamily: 'SUIT',
  );
  static const caption2 = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    fontFamily: 'SUIT',

  );
}

extension TextStyleHelpers on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  TextStyle withSize(double size) => copyWith(fontSize: size);

  TextStyle withDecoration(TextDecoration decoration) =>
      copyWith(decoration: decoration);
}