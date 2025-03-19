import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _householdIdController = TextEditingController();
  final _dietaryController = TextEditingController();

  List<String> _dietaryRequirements = [];

  void _generateHouseholdId() {
    _householdIdController.text = Random().nextInt(999).toString();
  }

  void _addDietaryRequirement() {
    String input = _dietaryController.text.trim();
    if (input.isNotEmpty && !_dietaryRequirements.contains(input)) {
      setState(() {
        _dietaryRequirements.add(input);
        _dietaryController.clear();
      });
    }
  }

  void _removeDietaryRequirement(String item) {
    setState(() {
      _dietaryRequirements.remove(item);
    });
  }

  void _registerUser() {
    String dietarySummary = _dietaryRequirements.join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registered with dietary needs: $dietarySummary')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.customAppBar(context: context, title: 'Register'),
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/ExpiryLogo.png', height: 150),
                  const SizedBox(height: 16),
                  _buildTextField(_firstNameController, 'First Name'),
                  _buildTextField(_lastNameController, 'Last Name'),
                  _buildTextField(_emailController, 'Email'),
                  _buildTextField(_householdIdController, 'Household ID', readOnly: true),
                  
                  const SizedBox(height: 16),
                  const Text('Dietary Requirements:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(_dietaryController, 'Add dietary requirement')),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: _addDietaryRequirement,
                      ),
                    ],
                  ),

                  Wrap(
                    spacing: 8.0,
                    children: _dietaryRequirements.map((item) {
                      return Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () => _removeDietaryRequirement(item),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: _registerUser, child: const Text('Register')),
                      ElevatedButton(onPressed: _generateHouseholdId, child: const Text('Create Household ID')),
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

  Widget _buildTextField(TextEditingController controller, String label, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        readOnly: readOnly,
      ),
    );
  }
}
