import 'package:expiry_eats/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/screens/settings.dart';

class Constants {
  static AppBar customAppBar({required BuildContext context, String? title}) =>
      AppBar(
        automaticallyImplyLeading: false, // removes back button
        foregroundColor: Colors.white,
        title: Text(
          title!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, size: 30.0), // Profile Icon
            onSelected: (String value) {
              if (value == "Profile") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              } else if (value == "Settings") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(), // Navigate to Settings
                  ),
                );
              } else if (value == "Logout") {
                // Not Functional Yet
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: "Profile",
                child: Text("Profile"),
              ),
              const PopupMenuItem<String>(
                value: "Settings",
                child: Text("Settings"),
              ),
              const PopupMenuItem<String>(
                value: "Logout",
                child: Text("Logout"),
              ),
            ],
          ),
        ],
        backgroundColor: AppTheme.primary40,
      );
}