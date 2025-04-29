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
  String? _selectedRequirement; // Move selectedRequirement to the state

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

  Widget _buildDietarySection(User user) {
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
          children: user.dietaryRequirements
              .map((requirement) => Chip(
                    label: Text(requirement),
                    backgroundColor: AppTheme.primary80.withOpacity(0.2),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: _isEditing
                        ? () => _removeDietaryRequirement(user, requirement)
                        : null,
                  ))
              .toList(),
        ),
        if (_isEditing) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRequirement, // Use the state variable
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
                      _selectedRequirement = value; // Update state
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
                onPressed: _selectedRequirement != null
                    ? () {
                        _addDietaryRequirement(user, _selectedRequirement!);
                        setState(() {
                          _selectedRequirement = null; // Reset the dropdown
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
      Provider.of<UserProvider>(context, listen: false).setUser(user.copyWith(
          dietaryRequirements: List.from(user.dietaryRequirements)));
    });
  }

  void _addDietaryRequirement(User user, String requirement) {
    setState(() {
      if (dietaryRequirements.contains(requirement) &&
          !user.dietaryRequirements.contains(requirement)) {
        user.dietaryRequirements.add(requirement);
        Provider.of<UserProvider>(context, listen: false).setUser(
          user.copyWith(
              dietaryRequirements: List.from(user.dietaryRequirements)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Invalid or duplicate dietary requirement')),
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
                : _buildProfileCard(user)),
      ),
    );
  }

  Widget _buildProfileCard(User user) {
    return SizedBox(
      height: 400, // Set a fixed height for the card
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'First Name: ${user.firstName}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Last Name: ${user.lastName}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: ${user.email}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Household ID: ${user.householdId}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildDietarySection(
                  user), // Include dietary requirements section
            ],
          ),
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
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Profile updated')));
        }
        setState(() => _isEditing = !_isEditing);
      },
    );
  }
}
