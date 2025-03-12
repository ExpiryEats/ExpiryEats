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
  late Map<String, List<Item>> _groupedDisplayItems;
  final List<Item> _allItems = [];
  List<Item> _displayItems = [];

  @override
  void initState() {
    super.initState();
    _populateTestData();
    _displayItems = _allItems;
    _groupedDisplayItems = _updateGroups();
  }

  Map<String, List<Item>> _updateGroups() {
    Map<String, List<Item>> output = {};

    for (final item in _displayItems) {
      final category = item.category;
      if (output.containsKey(category)) {
        output[category]!.add(item);
      } else {
        output[category] = [item];
      }
    }

    return output;
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
              onChanged: (query) {
                setState(() {
                  _displayItems = InventoryManager.filterInventory(query.toLowerCase(), _allItems);
                  _groupedDisplayItems = _updateGroups();
                });
              },
            ),
          ),
          // Inventory List
          Expanded(
            child: ListView(
              children: _groupedDisplayItems.entries.map((entry) {
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
                          key: ValueKey(item.name),
                          imageAssetPath: item.imgSrc,
                          itemName: item.name,
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
        backgroundColor: AppTheme.primary40,
        foregroundColor: AppTheme.surface,
        hoverColor: AppTheme.primary80,
        onPressed: () {
          setState(() {
            final newImagePath = 'assets/testing_image.jpg';
            final newItemName = 'Item ${_groupedDisplayItems.values.fold(0, (sum, items) => sum + items.length) + 1}';
            final newCategory = 'Fruits';

            if (_groupedDisplayItems.containsKey(newCategory)) {
              _groupedDisplayItems[newCategory]!.add(
                Item(
                  name: newItemName,
                  category: newCategory,
                  imgSrc: newImagePath,
                ));
            } else {
              _groupedDisplayItems[newCategory] = [
                Item(
                  name: newItemName,
                  category: newCategory,
                  imgSrc: newImagePath,
                )
              ];
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}