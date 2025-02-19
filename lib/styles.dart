import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle standard({Color? color}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle emphasised({Color? color}) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle large({Color? color}) {
    return TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle medium({Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle small({Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle bold({Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle heading({Color? color}) {
    return TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }

  static TextStyle setSize({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      color: color ?? Colors.black,
    );
  }
}