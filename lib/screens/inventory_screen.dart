import 'package:expiry_eats/styles.dart';
import 'package:flutter/foundation.dart';
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
  final Map<String, List<Map<String, String>>> _groupedItems = {};
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
        Item(name: 'Apples', category: 'Fruits', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Bananas', category: 'Fruits', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Carrots', category: 'Vegetables', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Milk', category: 'Dairy', imgSrc: 'assets/testing_image.jpg'),
        Item(name: 'Bread', category: 'Carbohydrates', imgSrc: 'assets/testing_image.jpg')
      ]);
      
      for (final item in testItems) {
        final category = item['category']!;
        if (_groupedItems.containsKey(category)) {
          _groupedItems[category]!.add(item);
        } else {
          _groupedItems[category] = [item];
        }
      }
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
          // Inventory List
          Expanded(
            child: ListView(
              children: _groupedItems.entries.map((entry) {
                final category = entry.key;
                final items  = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        category,
                        style: AppTextStyle.bold(),
                      ),
                    ),
                  
              
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3, // Adjusts teh space between boxes
                      crossAxisSpacing: 8, // Spacing between columns
                      mainAxisSpacing: 8, // Spacing between rows
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return InventoryItem(
                        key: ValueKey(item['itemName']),
                        imageAssetPath: item['imageAssetPath']!,
                        itemName: item['itemName']!,
                        category: category,
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),

    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        setState(() {
          final newImagePath = 'assets/testing_image.jpg';
          final newItemName = 'Item ${_groupedItems.values.fold(0, (sum, items) => sum + items.length) + 1}';
          final newCategory = 'Fruits';

          if (_groupedItems.containsKey(newCategory)) {
            _groupedItems[newCategory]! .add({

              'imageAssetPath': newImagePath,
              'itemName' : newItemName,
              'category' : newCategory,
            });
          } else {
            _groupedItems[newCategory] = [
            {
            'imageAssetPath' : newImagePath,
            'itemName' : newItemName,
            'category' : newCategory,
                }
              ];
            }
//My Code
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