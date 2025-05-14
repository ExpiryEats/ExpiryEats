.. _notificationManager:

Notification Manager
====================

Overview
--------

The **Notification Manager** calls to the database through the :ref:`databaseManager`, finding the user's current set of notifications to be displayed. This manager only has one function with which it handles its requests:

``Future<void> expiryNotifications(int personId) async {}``

* personId - The unique identifier of an individual user.

Getting Notifications
---------------------

The Notification Manager first retrieves the list of items associated with a user and any existing notifications.

.. code-block:: console

    final DatabaseService _db = DatabaseService();

    final items = await _db.getAllItems(personId);
    final existingNotifications = await _db.getNotifications(personId);


A list of all items expiring within the next 7 days is then derived from this:

.. code-block:: console

    final now = DateTime.now();
    final soon = now.add(const Duration(days: 7));

    final expiringItems = items.where((item) {
        final expiryDate = DateTime.parse(item['expiration_date']);
        return expiryDate.isBefore(soon);
    });

Once these items are returned, the Notification Manager will iterate over each of them and perform the following steps:

1. Determine how many days the item has left until expiry.

.. code-block:: console

    final expiryDate = DateTime.parse(item['expiration_date']);
    final daysLeft = expiryDate.difference(now).inDays;

    final message = daysLeft < 0
        ? "Your item '${item['item_name']}' has expired."
        : "Your item '${item['item_name']}' expires in $daysLeft day${daysLeft == 1 ? '' : 's'}.";

2. Check if a notification already exists for this item.

.. code-block:: console

    final exists = existingNotifications.any((n) =>
        n['person_id'] == personId &&
        n['message'] == message &&
        n['type_id'] == typeId &&
        n['item_id'] == itemId);

3. Add a notification if one does not exist.

.. code-block:: console

    if (!exists) {
        await _db.insertNotification(
            personId: personId,
            message: message,
            typeId: typeId,
            itemId: itemId,
        );
    }

.. autosummary::
   :toctree: generated

   ExpiryEats