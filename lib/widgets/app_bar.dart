import 'package:expiry_eats/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';

class Constants {
  static AppBar customAppBar({required BuildContext context, String? title}) => AppBar(
    foregroundColor: Colors.white,
    title: Text(
      title!,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.account_circle, size: 30.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        }
      ),
    ],
    backgroundColor: AppTheme.primary40,
  );
}