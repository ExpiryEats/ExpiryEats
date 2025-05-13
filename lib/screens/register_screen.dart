import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
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

    try {
      final response = await authManager.signUp(
        email,
        password,
        firstName,
        lastName,
        selectedRestrictionIds,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You have been registered successfully!')),
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
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '').trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(message.isNotEmpty ? message : 'Registration failed.')),
      );
    }
  }

  void _showDietaryRequirementsDialog(List<Map<String, dynamic>> restrictions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, localSetState) {
            return AlertDialog(
              title: const Text('Select Dietary Requirements'),
              content: SingleChildScrollView(
                child: Column(
                  children: restrictions.map((entry) {
                    final id = entry['restriction_id'] as int;
                    final name = entry['restriction_name'] as String;
                    return CheckboxListTile(
                      title: Text(name),
                      value: selectedRestrictionIds.contains(id),
                      onChanged: (bool? value) {
                        localSetState(() {
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

  Widget _buildInput(String label, Function(String) onChanged,
      {bool obscure = false}) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildRoundedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.primary40,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size.fromHeight(50),
        elevation: 2,
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restrictionTypes =
        Provider.of<CacheProvider>(context).cache.dietaryRestrictionTypes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primary80,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/ExpiryLogo.png', height: 150),
                    const SizedBox(height: 16),
                    _buildInput('First Name', (val) => firstName = val),
                    const SizedBox(height: 16),
                    _buildInput('Last Name', (val) => lastName = val),
                    const SizedBox(height: 16),
                    _buildInput('Email', (val) => email = val),
                    const SizedBox(height: 16),
                    _buildInput('Password', (val) => password = val,
                        obscure: true),
                    const SizedBox(height: 16),
                    _buildRoundedButton(
                      'Select Dietary Requirements',
                      () => _showDietaryRequirementsDialog(restrictionTypes),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: selectedRestrictionIds.map((id) {
                        final match = restrictionTypes.firstWhere(
                          (element) => element['restriction_id'] == id,
                          orElse: () => {'restriction_name': 'Unknown'},
                        );
                        return Chip(
                          label: Text(match['restriction_name']),
                          onDeleted: () {
                            setState(() {
                              selectedRestrictionIds.remove(id);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildRoundedButton('Register', _handleRegister),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
