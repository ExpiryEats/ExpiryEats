import 'package:flutter/foundation.dart';
import 'package:expiry_eats/item.dart';

class InventoryProvider with ChangeNotifier {
  final List<Item> _items = [];

  List<Item> get items => List.unmodifiable(_items);

  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}
