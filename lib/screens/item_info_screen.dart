import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';
import 'package:intl/intl.dart';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:expiry_eats/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO: add editing inventory items

class IteminfoScreen extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String category;
  final String itemImage;
  final String itemDateAdded;
  final String itemExpiryDate;

  const IteminfoScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.category,
    required this.itemImage,
    required this.itemDateAdded,
    required this.itemExpiryDate,
  });


  @override
  State<IteminfoScreen> createState() => _IteminfoScreenState();
}


class _IteminfoScreenState extends State<IteminfoScreen> {
  bool _isDeleting = false;

  Future<void> _confirmDeleteItem() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content: Text("Delete ${widget.itemName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _deleteItem();
    }
  }

  Future<void> _deleteItem() async {
    if (!mounted) return;
    
    setState(() => _isDeleting = true);
    
    try {
      // Delete from database
      await DatabaseService().deleteItem(widget.itemId);
      
      // Delete image 
      if (widget.itemImage.startsWith('http')) {
        final fileName = widget.itemImage.split('/').last;
        await Supabase.instance.client.storage
          .from('item-images')
          .remove([fileName]);
      }

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(initialTabIndex: 1),
          ),
          (route) => false,
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
        actions: [
          if (_isDeleting)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _confirmDeleteItem,
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              image: widget.itemImage.startsWith('http')? NetworkImage(widget.itemImage) as ImageProvider : AssetImage(widget.itemImage),
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/testing_image.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.itemName,
              style: AppTextStyle.bold(),
            ),
            const SizedBox(height: 20),
            Text(
              'Food Category: ${widget.category}',
              style: AppTextStyle.medium(),
            ),
            const SizedBox(height: 20),
            Text(
              'Date Added: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.itemDateAdded))}',
              style: AppTextStyle.standard(),
            ),
            const SizedBox(height: 10),
            Text(
              'Expiry Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.itemExpiryDate))}',
              style: AppTextStyle.small(),
            )
          ],
        ),
      ),
    );
  }
}
