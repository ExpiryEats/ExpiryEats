import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:intl/intl.dart';
import 'package:expiry_eats/widgets/image_service.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  File? _selectedImage;
  final ImageService _imageService = ImageService();

  int? _selectedCategoryId;
  int? _selectedStorageTypeId;
  DateTime? _selectedExpiryDate;

  @override
  void dispose() {
    _nameController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    try {
      final File? imageFile = await (source == ImageSource.camera? _imageService.takePhoto(): ImageService().chooseFromGallery());

      if (imageFile != null && mounted) {
        setState(() => _selectedImage = imageFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image error ${e.toString()}'))
        );
      }
    }
  }

   void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              _handleImageSelection(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _handleImageSelection(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }


  Future<void> _scanBarcode() async {
    final String? barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerScreen(),
        ),
      );

      if (barcode != null && mounted) {
        await _fetchProductInfo(barcode);
    }
  }

  Future<void> _fetchProductInfo(String  barcode) async {
    try {
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final productData = jsonDecode(response.body);

        if (productData['status'] == 1) {
          final product = productData['product'];
          setState(() {
            //Autofilling item name
            _nameController.text = product['product_name']?.toString() ?? '';
            
            // Autofills expiry date if avaliable
            if (product['expiration_date'] != null) {
              _selectedExpiryDate = DateFormat('yyyy-MM-dd').parse(
                product['expiration_date'].toString()
              );
              _expiryController.text = DateFormat('dd/MM/yyyy').format(_selectedExpiryDate!);
            }
            
            // Auto selects category if possible
            _autoSelectCategory(product['categories']?.toString());
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product not found in database')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching product info ${e.toString()}')),
        );
      }
    }
  }

  void _autoSelectCategory(String? categories) {
    if (categories == null) return;
    
    final cache = Provider.of<CacheProvider>(context, listen: false);
    final categoryList = categories.split(',').map((c) => c.trim()).toList();
    
    for (final category in categoryList) {
      final match = cache.cache.categories.firstWhere(
        (c) => c['category_name'].toString().toLowerCase().trim() == category.toLowerCase().trim(),
        orElse: () => {},
      );
      
      if (match.isNotEmpty) {
        setState(() => _selectedCategoryId = match['category_id']);
        break;
      }
    }
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

  void _submit() async {
    final cache = Provider.of<CacheProvider>(context, listen: false);

    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedStorageTypeId != null &&
        _selectedExpiryDate != null &&
        cache.cache.userId != null) {

      String? imageUrl;
      if (_selectedImage != null) {
        try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await Supabase.instance.client.storage
          .from('item-images')
          .upload(fileName, _selectedImage!);

        imageUrl = Supabase.instance.client.storage
          .from('item-images')
          .getPublicUrl(fileName);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image upload failed: ${e.toString()}'))
          );
        }
        return;
      }
    }
      final newItem = Item(
        personId: cache.cache.userId!,
        categoryId: _selectedCategoryId!,
        storageTypeId: _selectedStorageTypeId!,
        itemName: formatItemName(_nameController.text),
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
              GestureDetector(
                onTap: _showImageSourceSelector,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _selectedImage != null? Image.file(
                    _selectedImage!, fit: BoxFit.cover): Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 40),
                        SizedBox(height: 8),
                        Text('Add a photo'),
                      ],                     
                    ),
                ),
              ),
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
