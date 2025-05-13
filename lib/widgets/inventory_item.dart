import 'package:expiry_eats/screens/item_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';

class InventoryItem extends StatelessWidget {
  final int itemId;
  final String itemName;
  final String category;
  final String itemDateAdded;
  final String itemExpiryDate;
  final String? imageUrl;

  const InventoryItem({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.category,
    required this.itemDateAdded,
    required this.itemExpiryDate,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMissing = imageUrl == null ||
        imageUrl!.trim().isEmpty ||
        imageUrl == 'NULL';
    final fallbackAsset = 'assets/testing_image.jpg';

    final ImageProvider imageProvider = isMissing
        ? AssetImage(fallbackAsset)
        : imageUrl!.startsWith('http')
            ? NetworkImage(imageUrl!)
            : AssetImage(imageUrl!) as ImageProvider;

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
                    itemImage: imageUrl ?? fallbackAsset,
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
                        image: imageProvider,
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