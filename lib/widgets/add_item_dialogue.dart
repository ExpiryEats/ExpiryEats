import 'package:flutter/material.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/screens/barcode_scanner_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:expiry_eats/managers/cache_provider.dart';

class AddItemDialogue extends StatefulWidget {
  final Function(Item) onItemAdded;
  const AddItemDialogue({super.key, required this.onItemAdded});

  @override
  State<AddItemDialogue> createState() => _AddItemDialogueState();
}

class _AddItemDialogueState extends State<AddItemDialogue> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime? _expiryDate;
  int? _selectedCategoryId;
  int? _selectedStorageId;
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _fetchProductInfo(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://world.openfoodfacts.org/api/v0/product/$barcode.json'),
      );
      if (response.statusCode == 200) {
        final productData = json.decode(response.body);
        if (productData['status'] == 1) {
          final product = productData['product'];
          setState(() {
            _nameController.text = product['product_name'] ?? '';
          });
        }
      }
    } catch (_) {}
  }

  void _submit() {
    if (!_formKey.currentState!.validate() ||
        _expiryDate == null ||
        _selectedCategoryId == null ||
        _selectedStorageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
      return;
    }

    final cache = Provider.of<CacheProvider>(context, listen: false).cache;

    final newItem = Item(
      personId: cache.userId!,
      categoryId: _selectedCategoryId!,
      storageTypeId: _selectedStorageId!,
      itemName: _nameController.text,
      expirationDate: _expiryDate!,
      quantity: int.tryParse(_quantityController.text) ?? 1,
      dateAdded: DateTime.now(),
    );

    widget.onItemAdded(newItem);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cache = Provider.of<CacheProvider>(context).cache;

    return AlertDialog(
      title: const Text('Add New Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : const AssetImage('assets/image.jpg') as ImageProvider,
                  child: _selectedImage == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter quantity' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: cache.categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat['category_id'],
                    child: Text(cat['category_name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedStorageId,
                decoration: const InputDecoration(labelText: 'Storage Type'),
                items: cache.storageTypes.map((s) {
                  return DropdownMenuItem<int>(
                    value: s['storage_type_id'],
                    child: Text(s['type_name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedStorageId = val),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(_expiryDate == null
                        ? 'No expiry date'
                        : 'Expires: ${_expiryDate!.toLocal().toIso8601String().substring(0, 10)}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickExpiryDate,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Barcode'),
                onPressed: () async {
                  final barcode = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const BarcodeScannerScreen()),
                  );
                  if (barcode != null) {
                    await _fetchProductInfo(barcode);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Add Item')),
      ],
    );
  }
}
