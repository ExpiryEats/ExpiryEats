class Item {
  final int? itemId;
  final int personId;
  final int categoryId;
  final int storageTypeId;
  final String itemName;
  final DateTime expirationDate;
  final DateTime dateAdded;
  final String? imageUrl;

  Item({
    this.itemId,
    required this.personId,
    required this.categoryId,
    required this.storageTypeId,
    required this.itemName,
    required this.expirationDate,
    required this.dateAdded,
    this.imageUrl ,
  });

Map<String, dynamic> toMap() {
  final map = <String, dynamic>{
    'person_id': personId,
    'category_id': categoryId,
    'storage_type_id': storageTypeId,
    'item_name': itemName,
    'expiration_date': expirationDate.toIso8601String(),
    'date_added': dateAdded.toIso8601String(),
  };

  if (imageUrl != null) {
    map['image_url'] = imageUrl!;
  }

  return map;
}

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemId: map['item_id'] as int?,
      personId: map['person_id'] as int,
      categoryId: map['category_id'] as int,
      storageTypeId: map['storage_type_id'] as int,
      itemName: map['item_name'] as String,
      expirationDate: DateTime.parse(map['expiration_date']),
      dateAdded: DateTime.parse(map['date_added']),
      imageUrl: map['image_url']?.toString(),
    );
  }
}