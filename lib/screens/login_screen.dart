import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:expiry_eats/managers/notification_manager.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authManager = AuthManager();
    final notificationManager = NotificationManager();
    final response = await authManager.logIn(email, password);

    if (response?.user != null) {
      // ignore: use_build_context_synchronously
      final cacheProvider = Provider.of<CacheProvider>(context, listen: false);
      await cacheProvider.fetchUserFromDatabase();

      await notificationManager
          .expiryNotifications(cacheProvider.cache.userId!);

      if (!mounted) return;
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('We were unable to log you in.')),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                color: AppTheme.background,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/ExpiryLogo.png', height: 160),
                      const SizedBox(height: 64),
                      _buildInputField('Email', emailController),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _handleLogin(
                          context,
                          emailController.text,
                          passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : _buildActionButton(
                              'Login',
                              () => _handleLogin(
                                context,
                                emailController.text,
                                passwordController.text,
                              ),
                            ),
                      const SizedBox(height: 16),
                      _buildActionButton(
                        'Register',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.primary40,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 2,
      ),
      child: Text(text),
    );
  }
}
