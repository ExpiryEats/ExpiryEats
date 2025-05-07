import 'package:expiry_eats/screens/barcode_scanner_screen.dart';
import 'package:expiry_eats/screens/inventory_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/item.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';



class AddItemDialogue extends StatefulWidget {

  final Function(Item) onItemAdded;

  const AddItemDialogue({super.key, required this.onItemAdded});

  @override
  State<AddItemDialogue> createState() => _AddItemDialogueState();
}


class _AddItemDialogueState extends State<AddItemDialogue> {
  final _formKey = GlobalKey <FormState>();
  final _nameController = TextEditingController();
  File? _selectedImage;
  FoodCatogories _selectedCategory = FoodCatogories.fruits;


  Future<void> _pickImageFromCamera() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose image from Gallery'),
                onTap: (){
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

Future<void> _pickImage (ImageSource source) async {
  try {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 100,
      maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage =  File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      ('failed to Pick an Image: $e');
  }
}


  void _submit() {
    if (_formKey.currentState! .validate()) {
      final newItem = Item(
        name: _nameController.text,
        category: _selectedCategory.displayName,
        imgSrc: _selectedImage?.path?? 'assets/image.jpg'
      );
      widget.onItemAdded(newItem);
      Navigator.pop(context);
    }
  }

  Future<void> _fetchProductInfo (String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'),
      );
      if (response.statusCode == 200) {
        final productData = json.decode(response.body);
        if (productData['Status'] == 1) {
          final product = productData['product'];
          if (mounted) {
            setState(() {
              _nameController.text = product ['product_name']?.toString() ?? '';
              if (product['categories'] != null) {
                _selectedCategory = FoodCatogories.values.firstWhere(
                  (cat) => cat.displayName == product['categories'],
                  orElse: () => FoodCatogories.miscellaneous,
                );
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching product: ${e.toString()}'),
          ),
        );
      }
    }
  } 


  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImageFromCamera,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _selectedImage != null? FileImage(_selectedImage!):
                    const AssetImage('assets/image.jpg') as ImageProvider,
                  child: _selectedImage == null?
                    const Icon(Icons.add_a_photo, size: 10):
                    null,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.barcode_reader),
                      label: const Text('Scan Barcode'),
                      onPressed: () async {
                        final barcode = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(
                            builder: (context)=> const BarcodeScannerScreen(),
                          ),
                        );
                        if (barcode != null && mounted) {
                          _fetchProductInfo(barcode);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Upload Photo'),
                      onPressed: () => _pickImage,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // itemName

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              //Category

              DropdownButtonFormField<FoodCatogories>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: FoodCatogories.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                    );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
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
