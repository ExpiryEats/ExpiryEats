import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/managers/cache_provider.dart';

// TODO: make functional with db

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<TextEditingController> _controllers;
  bool _isEditing = false;
  String? _selectedRequirement;

  final List<String> _allDietaryOptions = [
    'Avocados', 'Bananas', 'Celery', 'Chocolate', 'Citrus Fruits', 'Coconut', 'Coffee',
    'Corn', 'Eggs', 'Fish', 'Food Additives', 'Gelatin', 'Kiwi', 'Legumes', 'Lupin',
    'Meat Allergies', 'Milk', 'Mollusks', 'Mustard', 'None', 'Nuts', 'Oats', 'Peanuts',
    'Potatoes', 'Rice', 'Sesame', 'Shellfish', 'Soy', 'Strawberries', 'Tomatoes',
    'Tree Nuts', 'Wheat',
  ];

  @override
  void initState() {
    super.initState();
    final cache = Provider.of<CacheProvider>(context, listen: false).cache;
    _controllers = [
      TextEditingController(text: cache.firstName ?? ''),
      TextEditingController(text: cache.lastName ?? ''),
      TextEditingController(text: cache.email ?? ''),
      TextEditingController(text: cache.householdId ?? ''),
    ];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheProvider>(context).cache;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primary80,
        actions: [_buildEditButton()],
      ),
      body: Container(
        color: AppTheme.primary80,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: cache.firstName == null
              ? const Text(
                  'No user data',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              : _buildProfileCard(cache),
        ),
      ),
    );
  }

  Widget _buildProfileCard(cache) {
    return Container(
      width: 550,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/ExpiryLogo.png', height: 200),
            const SizedBox(height: 16),
            const Divider(color: Colors.black, thickness: 5),
            const SizedBox(height: 16),
            const Text('Profile Details', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ..._buildEditableFields(),
            _buildDietarySection(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEditableFields() {
    const labels = ['First Name', 'Last Name', 'Email', 'Household ID'];

    return List.generate(labels.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TextField(
          controller: _controllers[index],
          decoration: InputDecoration(
            labelText: labels[index],
            border: const OutlineInputBorder(),
          ),
          enabled: _isEditing,
        ),
      );
    });
  }

  Widget _buildDietarySection() {
    final cacheProvider = Provider.of<CacheProvider>(context);

    return Column(
      children: [
        const SizedBox(height: 16),
        const Text('Dietary Requirements:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: cacheProvider.cache.dietaryRequirements.map((req) {
            return Chip(
              label: Text(req),
              backgroundColor: AppTheme.primary80.withOpacity(0.2),
              deleteIcon: const Icon(Icons.close),
              onDeleted: _isEditing ? () => _removeDietaryRequirement(req) : null,
            );
          }).toList(),
        ),
        if (_isEditing) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRequirement,
                  items: _allDietaryOptions
                      .where((option) => !cacheProvider.cache.dietaryRequirements.contains(option))
                      .map((req) => DropdownMenuItem(value: req, child: Text(req)))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedRequirement = value),
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
                        _addDietaryRequirement(_selectedRequirement!);
                        setState(() => _selectedRequirement = null);
                      }
                    : null,
                child: const Text('Add'),
              ),
            ],
          ),
        ]
      ],
    );
  }

  void _removeDietaryRequirement(String requirement) {
    final cacheProvider = Provider.of<CacheProvider>(context, listen: false);
    final updatedRequirements = List<String>.from(cacheProvider.cache.dietaryRequirements)
      ..remove(requirement);
    cacheProvider.setUserData(dietaryRequirements: updatedRequirements);
  }

  void _addDietaryRequirement(String requirement) {
    final cacheProvider = Provider.of<CacheProvider>(context, listen: false);
    final updatedRequirements = List<String>.from(cacheProvider.cache.dietaryRequirements)
      ..add(requirement);
    cacheProvider.setUserData(dietaryRequirements: updatedRequirements);
  }

  Widget _buildEditButton() {
    return IconButton(
      icon: Icon(_isEditing ? Icons.check : Icons.edit),
      onPressed: () {
        if (_isEditing) {
          final cacheProvider = Provider.of<CacheProvider>(context, listen: false);
          cacheProvider.setUserData(
            firstName: _controllers[0].text,
            lastName: _controllers[1].text,
            email: _controllers[2].text,
            householdId: _controllers[3].text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated')),
          );
        }
        setState(() => _isEditing = !_isEditing);
      },
    );
  }
}