import 'package:expiry_eats/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _householdIdController = TextEditingController();
  final Set<String> _selectedDietaryRequirements = {};

  final List<String> _dietaryRequirements = [
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

void _registerUser() {
  final dietaryRequirements = _selectedDietaryRequirements.toList();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Selected: ${dietaryRequirements.join(', ')}')),
  );
}

void _showDietaryRequirementsDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Dietary Requirements'),
        content: SingleChildScrollView(
          child: Column(
            children: _dietaryRequirements.map((String requirement) {
              return CheckboxListTile(
                title: Text(requirement),
                value: _selectedDietaryRequirements.contains(requirement),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedDietaryRequirements.add(requirement);
                    } else {
                      _selectedDietaryRequirements.remove(requirement);
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
            },
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}
  void _generateHouseholdId() {
    final random = Random();
    final householdId = random.nextInt(999); 
    _householdIdController.text = householdId.toString();
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
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _householdIdController,
                    decoration: const InputDecoration(
                      labelText: 'Household ID',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  ElevatedButton(
  onPressed: _showDietaryRequirementsDialog,
  child: const Text('Select Dietary Requirements'),
),
const SizedBox(height: 8),
Wrap(
  spacing: 8.0,
  children: _selectedDietaryRequirements.map((requirement) {
    return Chip(
      label: Text(requirement),
      onDeleted: () {
        setState(() {
          _selectedDietaryRequirements.remove(requirement);
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
