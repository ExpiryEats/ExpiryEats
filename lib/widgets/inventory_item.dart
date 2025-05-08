import 'package:expiry_eats/screens/item_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart'; 

class InventoryItem extends StatelessWidget {
  final int itemId;
  final String imageAssetPath;
  final String itemName;
  final String category;
  final String itemDateAdded;
  final String itemExpiryDate;

  const InventoryItem({
    super.key,
    required this.itemId,
    required this.imageAssetPath,
    required this.itemName,
    required this.category,
    required this.itemDateAdded,
    required this.itemExpiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center( 
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5, 
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IteminfoScreen(
                    itemId: itemId,
                    itemName: itemName,
                    category: category,
                    itemImage: imageAssetPath,
                    itemDateAdded: itemDateAdded,
                    itemExpiryDate: itemExpiryDate,
                  ),
                ),
              );
              debugPrint('Item tapped: $itemName');
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.5, 
              child: Row(
                children: [
                  // Image container
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      imageAssetPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Text content
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(
                          itemName,
                          style: AppTextStyle.bold(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: AppTextStyle.medium(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}