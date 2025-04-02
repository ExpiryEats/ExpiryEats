import 'package:expiry_eats/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/screens/login_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}