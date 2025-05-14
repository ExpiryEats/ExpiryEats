Notification Manager
====================

.. _notificationManager:

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



.. autosummary::
   :toctree: generated

   ExpiryEats