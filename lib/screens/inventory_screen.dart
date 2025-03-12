import 'package:expiry_eats/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/widgets/inventory_item.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  
  final Map<String, List<Map<String, String>>> _groupedItems = {};

  @override
  void initState() {
    super.initState();
    _populateTestData();
  }

  void _populateTestData() {
    // Test items for list
    final testItems = [

        {
          'imageAssetPath': 'assets/testing_image.jpg',
          'itemName': 'Apples',
          'category': 'Fruits',
        },
        {
          'imageAssetPath': 'assets/testing_image.jpg',
          'itemName': 'Bananas',
          'category': 'Fruits',
        },
        {
          'imageAssetPath': 'assets/testing_image.jpg',
          'itemName': 'Carrots',
          'category': 'Vegetables',
        },
        {
          'imageAssetPath': 'assets/testing_image.jpg',
          'itemName': 'Milk',
          'category': 'Dairy',
        },
        {
          'imageAssetPath': 'assets/testing_image.jpg',
          'itemName': 'Bread',
          'category': 'Carbohydrates',
        },
      ];


      for (final item in testItems) {
        final category = item['category']!;
        if (_groupedItems.containsKey(category)) {
          _groupedItems[category]!.add(item);
        } else {
          _groupedItems[category] = [item];
        }
      }

      setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar Area (Placeholder for now)
          Container(
            height: 120, 
            color: Colors.green[200], // Background
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Search Bar',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
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
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}