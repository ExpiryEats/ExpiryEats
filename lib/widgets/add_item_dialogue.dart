import 'dart:convert';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:expiry_eats/screens/barcode_scanner_screen.dart';

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

  Future<void> _scanBarcode() async {
    final String? barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (barcode != null && mounted) {
      await _fetchProductInfo(barcode);
    }
  }

  Future<void> _fetchProductInfo(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://world.openfoodfacts.org/api/v2/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final productData = jsonDecode(response.body);
        if (productData['status'] == 1) {
          final product = productData['product'];

          setState(() {
            _nameController.text = product['product_name']?.toString() ?? '';

            if (product['expiration_date'] != null) {
              _selectedExpiryDate =
                  DateFormat('yyyy-MM-dd').parse(product['expiration_date']);
              _expiryController.text =
                  DateFormat('dd/MM/yyyy').format(_selectedExpiryDate!);
            }

            _autoSelectCategory(product['categories']?.toString());
          });
        } else {
          _showSnackBar('Product not found in database');
        }
      }
    } catch (e) {
      _showSnackBar('Error fetching product info: ${e.toString()}');
    }
  }

  void _autoSelectCategory(String? categories) {
    if (categories == null) return;

    final cache = Provider.of<CacheProvider>(context, listen: false);
    final categoryList = categories.split(',').map((c) => c.trim()).toList();

    for (final category in categoryList) {
      final match = cache.cache.categories.firstWhere(
        (c) =>
            c['category_name'].toString().toLowerCase() ==
            category.toLowerCase(),
        orElse: () => {},
      );

      if (match.isNotEmpty) {
        setState(() => _selectedCategoryId = match['category_id']);
        break;
      }
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

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  void _submit() async {
    final cache = Provider.of<CacheProvider>(context, listen: false);
    final formattedName = formatItemName(_nameController.text);
    final imageUrl = await UnsplashService.fetchImageUrl(formattedName);

    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedStorageTypeId != null &&
        _selectedExpiryDate != null &&
        cache.cache.userId != null) {
      final newItem = Item(
        personId: cache.cache.userId!,
        categoryId: _selectedCategoryId!,
        storageTypeId: _selectedStorageTypeId!,
        itemName: formattedName,
        expirationDate: _selectedExpiryDate!,
        dateAdded: DateTime.now(),
        imageUrl: imageUrl,
      );

      widget.onItemAdded(newItem);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      _showSnackBar('Please complete all fields');
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
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _scanBarcode,
                      label: const Text('Scan Barcode'),
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
            child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Add Item')),
      ],
    );
  }
}
