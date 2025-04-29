import 'package:expiry_eats/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'login_screen.dart';

import 'package:expiry_eats/managers/database_manager.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  final Map<String, int> dietaryRestrictions = {
    'Vegan': 1,
    'Vegetarian': 2,
    'Gluten-Free': 3,
    'Nut-Free': 4,
    'Dairy-Free': 5,
  };

  List<int> selectedRestrictionIds = [];

  void _handleRegister() async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final authManager = AuthManager();

    final response = await authManager.signUp(
        email, password, firstName, lastName, selectedRestrictionIds);

    if (response != null && response.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have been registered successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed.')),
      );
    }
  }

  void _showDietaryRequirementsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Dietary Requirements'),
              content: SingleChildScrollView(
                child: Column(
                  children: dietaryRestrictions.entries.map((entry) {
                    final name = entry.key;
                    final id = entry.value;
                    return CheckboxListTile(
                      title: Text(name),
                      value: selectedRestrictionIds.contains(id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedRestrictionIds.add(id);
                          } else {
                            selectedRestrictionIds.remove(id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 400,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/ExpiryLogo.png', height: 150),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => firstName = value,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => lastName = value,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => email = value,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showDietaryRequirementsDialog,
                    child: const Text('Select Dietary Requirements'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: selectedRestrictionIds.map((id) {
                      final name = dietaryRestrictions.entries
                          .firstWhere((element) => element.value == id)
                          .key;

                      return Chip(
                        label: Text(name),
                        onDeleted: () {
                          setState(() {
                            selectedRestrictionIds.remove(id);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _handleRegister,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
