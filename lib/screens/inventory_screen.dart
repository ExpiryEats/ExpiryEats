import 'package:flutter/material.dart';
import 'package:expiry_eats/widgets/inventory_item.dart';


class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  
  final List<Map<String, String>> _boxes = [];

  @override
  void initState() {
    super.initState();
    _populateTestData();
  }

  void _populateTestData() {
    // Test items for list
    setState(() {
      _boxes.addAll([
        {
          'imageAssetPath': 'lib/assets/testing_image.jpg',
          'itemName': 'Apples',
        },
        {
          'imageAssetPath': 'lib/assets/testing_image.jpg',
          'itemName': 'Bananas',
        },
        {
          'imageAssetPath': 'lib/assets/testing_image.jpg',
          'itemName': 'Carrots',
        },
        {
          'imageAssetPath': 'lib/assets/testing_image.jpg',
          'itemName': 'Milk',
        },
        {
          'imageAssetPath': 'lib/assets/testing_image.jpg',
          'itemName': 'Bread',
        },
      ]);
    });
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
          // Inventory Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3, // Adjusts teh space between boxes
                crossAxisSpacing: 8, // Spacing between columns
                mainAxisSpacing: 8, // Spacing between rows
              ),
              itemCount: _boxes.length,
              itemBuilder: (context, index) {
                final item = _boxes[index];
                return InventoryItem(
                  key: ValueKey(item['itemName']),
                  imageAssetPath: item['imageAssetPath']!,
                  itemName: item['itemName']!,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            final newImagePath = 'lib/assets/testing_image.jpg';
            final newItemName = 'Item ${_boxes.length + 1}';

            _boxes.add({
              'imageAssetPath': newImagePath,
              'itemName': newItemName,
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}