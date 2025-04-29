import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';

import 'package:expiry_eats/managers/database_manager.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _handleLogin(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return null;
    }

    final authManager = AuthManager();

    final response = await authManager.logIn(email, password);

    if (response?.user != null) {
      final cacheProvider = Provider.of<CacheProvider>(context, listen: false);

      await cacheProvider.fetchUserFromDatabase();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('We were unable to log you in.')),
      );
    }
  }

  Widget _buildLoginCard(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 700,
        height: 700,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/ExpiryLogo.png', height: 160),
            const Text('Expiry Eats',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildInputField('Email', emailController),
            const SizedBox(height: 16),
            _buildInputField('Password', passwordController, isPassword: true),
            const SizedBox(height: 32),
            _buildActionButton(
                'Login',
                () => _handleLogin(
                    context, emailController.text, passwordController.text)),
            const SizedBox(height: 16),
            _buildActionButton(
                'Register',
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()))),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16),
        child: Center(child: _buildLoginCard(context)),
      ),
    );
  }
}
