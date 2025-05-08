import 'package:expiry_eats/styles.dart';
import 'package:expiry_eats/widgets/add_item_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/widgets/inventory_item.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:expiry_eats/managers/database_manager.dart';

// TODO: add images from unsplash api
// TODO: add quantity

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  Map<String, List<Item>> _groupedDisplayItems = {};
  List<Item> _allItems = [];
  List<Item> _displayItems = [];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final cache = Provider.of<CacheProvider>(context, listen: false);

    if (cache.cache.userId == null) return;

    final dbService = DatabaseService();
    final fetchedItems = await dbService.getAllItems(cache.cache.userId!);

    setState(() {
      _allItems = fetchedItems.map((data) => Item.fromMap(data)).toList();
      _displayItems = _allItems;
      _groupedDisplayItems = _updateGroups();
    });
  }

  Map<String, List<Item>> _updateGroups() {
    final cache = Provider.of<CacheProvider>(context, listen: false);
    final categories = cache.cache.categories;

    Map<String, List<Item>> output = {};

    for (final item in _displayItems) {
      final matchingCategory = categories.firstWhere(
        (cat) => cat['category_id'] == item.categoryId,
        orElse: () => {'category_name': 'Unknown'},
      );

      final categoryName = matchingCategory['category_name'] as String;

      if (output.containsKey(categoryName)) {
        output[categoryName]!.add(item);
      } else {
        output[categoryName] = [item];
      }
    }

    return output;
  }

  void _addNewItem(Item newItem) async {
    final dbService = DatabaseService();
    await dbService.insertItem(newItem.toMap());

    await _loadInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: 'Search Inventory',
              onChanged: (query) {
                setState(() {
                  _displayItems = _allItems.where((item) {
                    return item.itemName
                        .toLowerCase()
                        .contains(query.toLowerCase());
                  }).toList();
                  _groupedDisplayItems = _updateGroups();
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: _groupedDisplayItems.entries.map((entry) {
                final categoryName = entry.key;
                final items = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        categoryName,
                        style: AppTextStyle.bold(),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return InventoryItem(
                          key: ValueKey(item.itemId ?? item.itemName),
                          imageAssetPath: 'assets/testing_image.jpg',
                          itemName: item.itemName,
                          category: categoryName,
                          itemDateAdded: item.dateAdded.toIso8601String(),
                          itemExpiryDate: item.expirationDate.toIso8601String(),
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
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddItemDialogue(
            onItemAdded: (newItem) {
              _addNewItem(newItem);
            },
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
