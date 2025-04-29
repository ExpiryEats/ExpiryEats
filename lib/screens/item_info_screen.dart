import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';
import 'package:intl/intl.dart';

class IteminfoScreen extends StatelessWidget {
  final String itemName;
  final String category;
  final String itemImage;
  final String itemDateAdded;
  final String itemExpiryDate;

  const IteminfoScreen({
    super.key,
    required this.itemName,
    required this.category,
    required this.itemImage,
    required this.itemDateAdded,
    required this.itemExpiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              debugPrint('Edit $itemName');
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