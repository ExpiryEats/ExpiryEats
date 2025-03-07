import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Temporary Dashboard Text",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}