import 'package:expiry_eats/managers/database_manager.dart';

class NotificationManager {
  final DatabaseService _db = DatabaseService();

  Future<void> expiryNotifications(int personId) async {
    print("Checking for missing expiry notifications for user $personId");

    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));
    final items = await _db.getAllItems(personId);
    final existingNotifications = await _db.getNotifications(personId);

    final expiringItems = items.where((item) {
      final expiryDate = DateTime.parse(item['expiration_date']);
      return expiryDate.isBefore(soon);
    });

    for (final item in expiringItems) {
      final expiryDate = DateTime.parse(item['expiration_date']);
      final daysLeft = expiryDate.difference(now).inDays;

      final message = daysLeft < 0
          ? "Your item '${item['item_name']}' has expired."
          : "Your item '${item['item_name']}' expires in $daysLeft day${daysLeft == 1 ? '' : 's'}.";

      const typeId = 2;
      final itemId = item['item_id'] as int;

      final exists = existingNotifications.any((n) =>
          n['person_id'] == personId &&
          n['message'] == message &&
          n['type_id'] == typeId &&
          n['item_id'] == itemId);

      if (!exists) {
        await _db.insertNotification(
          personId: personId,
          message: message,
          typeId: typeId,
          itemId: itemId,
        );
      }
    }
  }
}
