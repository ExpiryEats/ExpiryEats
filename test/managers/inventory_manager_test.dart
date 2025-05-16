import 'package:expiry_eats/item.dart';
import 'package:expiry_eats/managers/inventory_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InventoryManager manager = InventoryManager();

  group('Inventory Manager Filter Inventory', () {
    final items = [
      Item(itemName: 'Banana', personId: 1, categoryId: 1, storageTypeId: 1, expirationDate: DateTime(2025), dateAdded: DateTime(2025)),
      Item(itemName: 'Apple', personId: 1, categoryId: 1, storageTypeId: 1, expirationDate: DateTime(2025), dateAdded: DateTime(2025)),
      Item(itemName: 'Beef', personId: 1, categoryId: 2, storageTypeId: 3, expirationDate: DateTime(2025), dateAdded: DateTime(2025)),
    ];

    test('filterInventory returns matching items', () {
      final result = manager.filterInventory('Banana', items);

      expect(result.length, 1);
      expect(result.first.itemName, 'Banana');
    });

    test('filterInventory is case-insensitive', () {
      final result = manager.filterInventory('APpLe', items);

      expect(result.length, 1);
      expect(result.first.itemName, 'Apple');
    });

    test('filterInventory returns empty list when no match', () {
      final result = manager.filterInventory('bagel', items);

      expect(result, isEmpty);
    });

    test('Partial Matches are valid', () {
      final result = manager.filterInventory('ba', items);

      expect(result.length, 1);
      expect(result.first.itemName, 'Banana');
    });
  });

  group('formatItemName', () {
    InventoryManager manager = InventoryManager();

    test('Capitalises each word and trims whitespace', () {
      final result = manager.formatItemName('  green apples  ');
      expect(result, 'Green Apples');
    });

    test('Works with single word', () {
      final result = manager.formatItemName('banana');
      expect(result, 'Banana');
    });

    test('Empty input returns empty string', () {
      final result = manager.formatItemName('');
      expect(result, '');
    });
  });
}