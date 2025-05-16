import 'package:expiry_eats/item.dart';

class InventoryManager {
  List<Item> filterInventory(String? searchTerm, List<Item> allItems) {
    List<Item> output;
    if (searchTerm == null || searchTerm == '') {
      output = allItems;
    } else {
      output = allItems.where((item) => item.itemName.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }

    return output;
  }

  String formatItemName(String name) {
    return name
        .trim()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}