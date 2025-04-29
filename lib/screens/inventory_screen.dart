import 'package:expiry_eats/managers/inventory_provider.dart';
import 'package:expiry_eats/styles.dart';
import 'package:expiry_eats/widgets/add_item_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/widgets/inventory_item.dart';
import 'package:provider/provider.dart';

enum FoodCatogories {
  carbohydrates,
  dairy,
  fruits,
  protein,
  sweetsAndFats,
  vegetables,
  miscellaneous;

  String get displayName {
    switch (this) {
      case FoodCatogories.sweetsAndFats:
        return 'Sweets & Fats';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  String _searchTerm = '';

  Map<String, List<Item>> _groupItems(List<Item> items) {
    Map<String, List<Item>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<InventoryProvider>(context, listen: false);
    if (provider.items.isEmpty) {
      provider.addItem(Item(
          name: 'Apples',
          category: 'Fruits',
          imgSrc: 'assets/testing_image.jpg'));
      provider.addItem(Item(
          name: 'Bananas',
          category: 'Fruits',
          imgSrc: 'assets/testing_image.jpg'));
      provider.addItem(Item(
          name: 'Carrots',
          category: 'Vegetables',
          imgSrc: 'assets/testing_image.jpg'));
      provider.addItem(Item(
          name: 'Milk', category: 'Dairy', imgSrc: 'assets/testing_image.jpg'));
      provider.addItem(Item(
          name: 'Bread',
          category: 'Carbohydrates',
          imgSrc: 'assets/testing_image.jpg'));
      provider.addItem(Item(
          name: 'Cake',
          category: 'Sweets and Fats',
          imgSrc: 'assets/testing_image.jpg'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context);
    final allItems = provider.items;
    final filteredItems = _searchTerm.isEmpty
        ? allItems
        : allItems
            .where((item) => item.name.toLowerCase().contains(_searchTerm))
            .toList();
    final groupedItems = _groupItems(filteredItems);

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
                  _searchTerm = query.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: groupedItems.entries.map((entry) {
                final category = entry.key;
                final items = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(category, style: AppTextStyle.bold()),
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
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddItemDialogue(
            onItemAdded: (newItem) {
              Provider.of<InventoryProvider>(context, listen: false)
                  .addItem(newItem);
            },
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
