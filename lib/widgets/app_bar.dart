import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';

class Constants {
  static AppBar customAppBar({String? title}) => AppBar(
    foregroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
       
      ]
    ),
    backgroundColor: AppTheme.primary40,
  );
}