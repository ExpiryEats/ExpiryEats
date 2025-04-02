import 'package:expiry_eats/managers/user_model.dart';
import 'package:expiry_eats/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

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

class _ProfileScreenState extends State<ProfileScreen> {
  late final List<TextEditingController> _controllers;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _controllers = [
      TextEditingController(text: user?.firstName ?? ''),
      TextEditingController(text: user?.lastName ?? ''),
      TextEditingController(text: user?.email ?? ''),
      TextEditingController(text: user?.householdId ?? ''),
    ];
  }

  @override
  void dispose() {
    for (final controller in _controllers) controller.dispose();
    super.dispose();
  }

  Widget _buildProfileCard(User user) {
    return Container(
      width: 550,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/ExpiryLogo.png', height: 200),
            const SizedBox(height: 16),
            const Divider(color: Colors.black, thickness: 5.0),
            const SizedBox(height: 16),
            const Text('Profile Details', 
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ..._buildEditableFields(user),
            _buildDietarySection(user),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEditableFields(User user) {
    const labels = ['First Name', 'Last Name', 'Email', 'Household ID'];
    return List.generate(labels.length, (index) => Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextField(
        controller: _controllers[index],
        decoration: InputDecoration(
          labelText: labels[index],
          border: const OutlineInputBorder(),
        ),
        enabled: _isEditing,
      ),
    ));
  }

  Widget _buildDietarySection(User user) {
  String? selectedRequirement; // Holds the currently selected dietary requirement

  return Column(
    children: [
      const SizedBox(height: 16),
      const Text(
        'Dietary Requirements:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: user.dietaryRequirements.map((requirement) => Chip(
          label: Text(requirement),
          backgroundColor: AppTheme.primary80.withOpacity(0.2),
          deleteIcon: const Icon(Icons.close),
          onDeleted: _isEditing
              ? () => _removeDietaryRequirement(user, requirement)
              : null,
        )).toList(),
      ),
      if (_isEditing) ...[
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedRequirement,
                items: dietaryRequirements
                    .where((requirement) =>
                        !user.dietaryRequirements.contains(requirement))
                    .map((requirement) => DropdownMenuItem(
                          value: requirement,
                          child: Text(requirement),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRequirement = value; // Update selected requirement
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Dietary Requirement',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: selectedRequirement != null
                  ? () {
                      _addDietaryRequirement(user, selectedRequirement!);
                      setState(() {
                        selectedRequirement = null; // Reset the dropdown
                      });
                    }
                  : null, // Disable button if no requirement is selected
              child: const Text('Add'),
            ),
          ],
        ),
      ],
    ],
  );
}

  void _removeDietaryRequirement(User user, String requirement) {
    setState(() {
      user.dietaryRequirements.remove(requirement);
      Provider.of<UserProvider>(context, listen: false).setUser(
        user.copyWith(dietaryRequirements: List.from(user.dietaryRequirements))
      );
    });
  }
  
  void _addDietaryRequirement(User user, String requirement) {
  setState(() {
    if (dietaryRequirements.contains(requirement) &&
        !user.dietaryRequirements.contains(requirement)) {
      user.dietaryRequirements.add(requirement);
      Provider.of<UserProvider>(context, listen: false).setUser(
        user.copyWith(dietaryRequirements: List.from(user.dietaryRequirements)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or duplicate dietary requirement')),
      );
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primary80,
        actions: [_buildEditButton(context)],
      ),
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: user == null 
            ? const Text('No user data', 
                style: TextStyle(color: Colors.white, fontSize: 25))
            : _buildProfileCard(user)
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return IconButton(
      icon: Icon(_isEditing ? Icons.check : Icons.edit),
      onPressed: () {
        if (_isEditing) {
          final user = Provider.of<UserProvider>(context, listen: false).user!;
          Provider.of<UserProvider>(context, listen: false).setUser(
            user.copyWith(
              firstName: _controllers[0].text,
              lastName: _controllers[1].text,
              email: _controllers[2].text,
              householdId: _controllers[3].text,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated')));
        }
        setState(() => _isEditing = !_isEditing);
      },
    );
  }
}