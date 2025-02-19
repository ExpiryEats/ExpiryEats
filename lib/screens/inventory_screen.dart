import 'package:expiry_eats/widgets/Inventory_box.dart';
import 'package:flutter/material.dart';



class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
InventoryScreenState createState() => InventoryScreenState();
}



class InventoryScreenState extends State<InventoryScreen> {

  List<InventoryBox> _boxes = [];




  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _boxes.length,
        itemBuilder: (context, index) {
          return _boxes[index];
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // Use your logic to get an imageAssetPath and itemName for the new InventoryBox
            final newImagePath = 'lib/assets/testing_image.jpg';
            final newItemName = 'Item Name';

            _boxes.add(InventoryBox(imageAssetPath: newImagePath, itemName: newItemName));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}