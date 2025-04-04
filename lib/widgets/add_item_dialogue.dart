import 'package:expiry_eats/screens/inventory_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/item.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedExpiryDate;
  final TextEditingController _dateController = TextEditingController();
  FoodCatogories _selectedCategory = FoodCatogories.fruits;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100)
    );

    if (picked != null) {
      setState(() {
        _selectedExpiryDate = picked;
        _dateController.text = DateFormat ('yyyy/MM/dd').format(picked);
      });
    }
  }


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
    if (_formKey.currentState! .validate() && _selectedExpiryDate != null) {
      final newItem = Item(
        name: _nameController.text,
        category: _selectedCategory.displayName,
        imgSrc: _selectedImage?.path?? 'assets/image.png',
        expiryDate: _selectedExpiryDate!,
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

              const SizedBox(height: 16),

              //Expiry Date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: _selectDate,
                    icon: Icon(Icons.calendar_today)
                    ),
                ),

                validator: (value) {
                  if (_selectedExpiryDate == null) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
                onTap: _selectDate,
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