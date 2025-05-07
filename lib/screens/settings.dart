import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';

// TODO: make functional with db

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedUnit = 'Metric (kg, liters)';

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning, color: Colors.red, size: 40),
        title: const Text('Delete Account', style: TextStyle(fontSize: 24)),
        content: const Text('All your data will be permanently removed. This action cannot be undone.'),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Add account deletion logic
              Navigator.pop(context);
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    String? subtitle,
    Color? iconColor,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: trailing,
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: Colors.grey.shade100,
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _showUnitsDialog() async {
    final unit = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Measurement System'),
        children: [
          RadioListTile(
            title: const Text('Metric (kg, liters)'),
            value: 'Metric (kg, liters)',
            groupValue: _selectedUnit,
            onChanged: (value) => Navigator.pop(context, value),
          ),
          RadioListTile(
            title: const Text('Imperial (lbs, gallons)'),
            value: 'Imperial (lbs, gallons)',
            groupValue: _selectedUnit,
            onChanged: (value) => Navigator.pop(context, value),
          ),
        ],
      ),
    );
    
    if (unit != null) {
      setState(() => _selectedUnit = unit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primary40,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 16),
        children: [
          _buildSettingsItem(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) => setState(() => _notificationsEnabled = value),
            ),
          ),
          _buildSettingsItem(
            icon: Icons.straighten,
            title: 'Measurement Units',
            subtitle: _selectedUnit,
            onTap: _showUnitsDialog,
          ),
          _buildSettingsItem(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () => Navigator.pushNamed(context, '/change-password'),
          ),
          _buildSettingsItem(
            icon: Icons.delete,
            title: 'Delete Account',
            iconColor: Colors.red,
            onTap: () => _showDeleteConfirmation(context),
          ),
          _buildSettingsItem(
            icon: Icons.info,
            title: 'About & Help',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'ExpiryEats',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.fastfood, size: 40),
              applicationLegalese: '© 2024 ExpiryEats\nReduce food waste effectively',
            ),
          ),
        ],
      ),
    );
  }
}