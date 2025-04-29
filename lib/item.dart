class Item {
  final int? itemId;
  final int personId;
  final int categoryId;
  final int storageTypeId;
  final String itemName;
  final DateTime expirationDate;
  final int quantity;
  final DateTime dateAdded;

  Item({
    this.itemId,
    required this.personId,
    required this.categoryId,
    required this.storageTypeId,
    required this.itemName,
    required this.expirationDate,
    required this.quantity,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'person_id': personId,
      'category_id': categoryId,
      'storage_type_id': storageTypeId,
      'item_name': itemName,
      'expiration_date': expirationDate.toIso8601String(),
      'quantity': quantity,
      'date_added': dateAdded.toIso8601String(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemId: map['item_id'] as int?,
      personId: map['person_id'] as int,
      categoryId: map['category_id'] as int,
      storageTypeId: map['storage_type_id'] as int,
      itemName: map['item_name'] as String,
      expirationDate: DateTime.parse(map['expiration_date']),
      quantity: map['quantity'] as int,
      dateAdded: DateTime.parse(map['date_added']),
    );
  }
}