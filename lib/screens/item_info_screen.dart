import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';
import 'package:intl/intl.dart';
import 'package:expiry_eats/managers/database_manager.dart';
import 'package:expiry_eats/screens/home_screen.dart';

// TODO: add editing inventory items

class IteminfoScreen extends StatelessWidget {
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

  Future<void> _confirmDeleteItem(BuildContext context, String itemName) async {
    final scaffoldContext = context;

    showDialog(
      context: scaffoldContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: Text(
              "Are you sure you want to delete \"$itemName\" from your inventory?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                showDialog(
                  context: scaffoldContext,
                  barrierDismissible: false,
                  builder: (context) => const AlertDialog(
                    content: SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                );

                await DatabaseService().deleteItem(itemId);
                debugPrint("Item deleted: $itemId");

                if (scaffoldContext.mounted) {
                  Navigator.of(scaffoldContext).pop();
                  Navigator.pushReplacement(
                    scaffoldContext,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(initialTabIndex: 1),
                    ),
                  );
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              debugPrint('Delete $itemName');
              _confirmDeleteItem(context, itemName);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              itemImage,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              itemName,
              style: AppTextStyle.bold(),
            ),
            const SizedBox(height: 20),
            Text(
              'Food Category: $category',
              style: AppTextStyle.medium(),
            ),
            const SizedBox(height: 20),
            Text(
              'Date Added: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(itemDateAdded))}',
              style: AppTextStyle.standard(),
            ),
            const SizedBox(height: 10),
            Text(
              'Expiry Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(itemExpiryDate))}',
              style: AppTextStyle.small(),
            )
          ],
        ),
      ),
    );
  }
}
