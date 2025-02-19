
import 'package:flutter/material.dart';

class InventoryBox extends StatelessWidget {
  final String imageAssetPath;
  final String itemName;

  const InventoryBox({super.key, required this.imageAssetPath, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imageAssetPath,
          height: 100,
          width: 200,
        ),
        Text(itemName),
      ],
    );
  }
}