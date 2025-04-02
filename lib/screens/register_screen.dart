import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/managers/user_model.dart';
import 'package:expiry_eats/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String householdId = '';
  List<String> dietaryRequirements = [
    'Avocados',
    'Bananas',
    'Celery',
    'Chocolate',
    'Citrus Fruits',
    'Coconut',
    'Coffee',
    'Corn',
    'Eggs',
    'Fish',
    'Food Additives',
    'Gelatin',
    'Kiwi',
    'Legumes',
    'Lupin',
    'Meat Allergies',
    'Milk',
    'Mollusks',
    'Mustard',
    'None',
    'Nuts',
    'Oats',
    'Peanuts',
    'Potatoes',
    'Rice',
    'Sesame',
    'Shellfish',
    'Soy',
    'Strawberries',
    'Tomatoes',
    'Tree Nuts',
    'Wheat'
  ];

  List<String> selectedDietaryRequirements = [];

  void _registerUser() {
  final user = User(
    firstName: firstName,
    lastName: lastName,
    email: email,
    householdId: householdId,
    dietaryRequirements: selectedDietaryRequirements,
  );

  
  Provider.of<UserProvider>(context, listen: false).setUser(user);

 
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Successfully registered')),
  );
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
                  children: dietaryRequirements.map((String requirement) {
                    return CheckboxListTile(
                      title: Text(requirement),
                      value: selectedDietaryRequirements.contains(requirement),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedDietaryRequirements.add(requirement);
                          } else {
                            selectedDietaryRequirements.remove(requirement);
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

  void _generateHouseholdId() {
    final random = Random();
    householdId = random.nextInt(999).toString();
    setState(() {});
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
                    onChanged: (value) => householdId = value,
                    decoration: InputDecoration(
                      labelText: 'Household ID',
                      border: const OutlineInputBorder(),
                      hintText: householdId.isEmpty
                          ? 'Enter or generate ID'
                          : householdId,
                    ),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: _showDietaryRequirementsDialog,
                    child: const Text('Select Dietary Requirements'),
                  ),
                  const SizedBox(height: 8),

                  
                  Wrap(
                    spacing: 8.0,
                    children: selectedDietaryRequirements.map((requirement) {
                      return Chip(
                        label: Text(requirement),
                        onDeleted: () {
                          setState(() {
                            selectedDietaryRequirements.remove(requirement);
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
                        onPressed: _registerUser,
                        child: const Text('Register'),
                      ),
                      ElevatedButton(
                        onPressed: _generateHouseholdId,
                        child: const Text('Create Household ID'),
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
