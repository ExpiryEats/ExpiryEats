import 'package:expiry_eats/managers/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:intl/intl.dart';

class AddItemDialogue extends StatefulWidget {
  final Function(Item) onItemAdded;

  const AddItemDialogue({super.key, required this.onItemAdded});

  @override
  State<AddItemDialogue> createState() => _AddItemDialogueState();
}

class _AddItemDialogueState extends State<AddItemDialogue> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expiryController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedStorageTypeId;
  DateTime? _selectedExpiryDate;

  @override
  void dispose() {
    _nameController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedExpiryDate = picked;
        _expiryController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  String formatItemName(String name) {
    return name
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  void _submit() async{
    final cache = Provider.of<CacheProvider>(context, listen: false);

    final formattedItemName = formatItemName(_nameController.text);

    final imageUrl = await UnsplashService.fetchImageUrl(formattedItemName);

    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedStorageTypeId != null &&
        _selectedExpiryDate != null &&
        cache.cache.userId != null) {
      final newItem = Item(
        personId: cache.cache.userId!,
        categoryId: _selectedCategoryId!,
        storageTypeId: _selectedStorageTypeId!,
        itemName: formattedItemName,
        expirationDate: _selectedExpiryDate!,
        dateAdded: DateTime.now(),
        imageUrl: imageUrl,
      );

      widget.onItemAdded(newItem);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheProvider>(context);

    return AlertDialog(
      title: const Text('Add New Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an item name'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: cache.cache.categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['category_id'],
                    child: Text(category['category_name']),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategoryId = value),
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedStorageTypeId,
                decoration: const InputDecoration(
                  labelText: 'Storage Type',
                  border: OutlineInputBorder(),
                ),
                items: cache.cache.storageTypes.map((type) {
                  return DropdownMenuItem<int>(
                    value: type['storage_type_id'],
                    child: Text(type['type_name']),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedStorageTypeId = value),
                validator: (value) =>
                    value == null ? 'Please select storage type' : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickExpiryDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (_) {
                      if (_selectedExpiryDate == null) {
                        return 'Please pick an expiry date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add Item'),
        ),
      ],
    );
  }
}
