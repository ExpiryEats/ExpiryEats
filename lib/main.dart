import 'package:expiry_eats/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/inventory_provider.dart';
import 'package:expiry_eats/managers/recipe_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
