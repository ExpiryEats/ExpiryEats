import 'package:expiry_eats/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/screens/settings.dart';
import 'package:expiry_eats/screens/login_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Constants {
  static AppBar customAppBar({required BuildContext context, String? title}) =>
      AppBar(
        automaticallyImplyLeading: false, // removes back button
        foregroundColor: Colors.white,
        title: Text(
          title!,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, size: 30.0), // Profile Icon
            onSelected: (String value) async {
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
                    builder: (context) => SettingsScreen(),
                  ),
                );
              } else if (value == "Logout") {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Confirmation"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text("Log Out"),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await Supabase.instance.client.auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
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
                child: Text("Log Out"),
              ),
            ],
          ),
        ],
        backgroundColor: AppTheme.primary40,
      );
}
