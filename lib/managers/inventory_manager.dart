import 'package:expiry_eats/item.dart';

class InventoryManager {
  static List<Item> filterInventory(String? searchTerm, List<Item> allItems) {
    List<Item> output;
    if (searchTerm == null || searchTerm == '') {
      output = allItems;
    } else {
      output = allItems.where((item) => item.itemName.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }

    return output;
  }
}