import 'package:expiry_eats/screens/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/item.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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


  Future<void> _pickImage()  async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } on PlatformException catch (e) {
      ('Failed to pick an image: $e');
    }
  }


  void _submit() {
    if (_formKey.currentState! .validate()) {
      final newItem = Item(
        name: _nameController.text,
        category: _selectedCategory.displayName,
        imgSrc: _selectedImage?.path?? 'assets/image.png'
      );
      widget.onItemAdded(newItem);
      Navigator.pop(context);
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
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _selectedImage != null? FileImage(_selectedImage!):
                    const AssetImage('assets/image.png') as ImageProvider,
                  child: _selectedImage == null?
                    const Icon(Icons.add_a_photo, size: 10):
                    null
                ),
              ),

              const SizedBox(height: 16),

              // Name

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
          child: const Text('canecel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add Item'),
        ),
      ],
    );
  }
}