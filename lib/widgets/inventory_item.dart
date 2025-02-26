import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart'; 

class InventoryItem extends StatelessWidget {
  final String imageAssetPath;
  final String itemName;

  const InventoryItem({
    super.key,
    required this.imageAssetPath,
    required this.itemName,
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
              debugPrint("Item tapped: $itemName");
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.5, 
              child: Row(
                children: [
                  // Image container
                  SizedBox(
                    width: 300,
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
                        const SizedBox(height: 64), // Adds some spacing
                        Text(
                          "Description...", 
                          style: AppTextStyle.small(),
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