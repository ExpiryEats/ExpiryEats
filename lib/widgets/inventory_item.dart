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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
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
              height: constraints.maxWidth * 0.6,
              child: Row(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageAssetPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(itemName, style: AppTextStyle.bold()),
                            const SizedBox(height: 4),
                            Text(category, style: AppTextStyle.medium()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}