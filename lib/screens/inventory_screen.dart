import 'package:expiry_eats/colors.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/managers/inventory_manager.dart';
import 'package:expiry_eats/widgets/inventory_item.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  
  final List<Item> _allItems = [];
  List<Item> _displayedItems = [];

  @override
  void initState() {
    super.initState();
    _populateTestData();
    _displayedItems = _allItems;
  }

  void _populateTestData() {
    // Test items for list
    setState(() {
      _allItems.addAll([
        Item(name: 'Apples', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Bananas', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Carrots', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Milk', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Bread', imgSrc: 'assets/testing_image.jpg')
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: 'Search Inventory',
              onChanged: (query) { setState(() => _displayedItems = InventoryManager.filterInventory(query.toLowerCase(), _allItems)); },
            ),
          ),
          // Inventory Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3, // Adjusts teh space between boxes
                crossAxisSpacing: 8, // Spacing between columns
                mainAxisSpacing: 8, // Spacing between rows
              ),
              itemCount: _displayedItems.length,
              itemBuilder: (context, index) {
                final item = _displayedItems[index];
                return InventoryItem(
                  key: ValueKey(item.name),
                  imageAssetPath: item.imgSrc,
                  itemName: item.name,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary40,
        foregroundColor: AppTheme.surface,
        hoverColor: AppTheme.primary80,
        onPressed: () {
          setState(() {
            final newImagePath = 'assets/testing_image.jpg';
            final newItemName = 'Item ${_allItems.length + 1}';

            _allItems.add(Item(name: newItemName, imgSrc: newImagePath));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}