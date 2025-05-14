.. _databaseManager:

Database Manager
================

Overview
--------

Get All Items
-------------

The Database Manager calls to the Supabase Database with the following method:

``Future<List<Map<String, dynamic>>> getAllItems(int personId) async {}``

* personId - The unique identifier of an individual user.

.. code-block:: console

    Future<List<Map<String, dynamic>>> getAllItems(int personId) async {
        final response = await _supabase
            .from('item')
            .select('*')
            .eq('person_id', personId)
            .order('item_name', ascending: true);

        return List<Map<String, dynamic>>.from(response);
    }

Insert An Item
--------------

This method simply adds an item to the database using its data:

``Future<void> insertItem(Map<String, dynamic> itemData) async {}``

* itemData - 

.. code-block:: console

    Future<void> insertItem(Map<String, dynamic> itemData) async {
        await _supabase.from('item').insert(itemData);
    }

Delete An Item
--------------

This method simply adds an item to the database using its data:

``Future<void> deleteItem(int itemId) async {}``

* itemId - The unique identifier for an individual item.

.. code-block:: console

    Future<void> deleteItem(int itemId) async {
        await _supabase.from('item').delete().eq('item_id', itemId);
    }

Get Dietary Requirements
------------------------

This method gets the dietary requirements set by users:

``Future<List<Map<String, dynamic>>> getPersonDietaryRestrictions(int personId) async {}``

* personId - The unique identifier of an individual user.

.. code-block:: console

    Future<List<Map<String, dynamic>>> getPersonDietaryRestrictions(int personId) async {
        final response = await _supabase
            .from('person_dietary_restrictions')
            .select('restriction_id, dietary_restrictions(restriction_name)')
            .eq('person_id', personId);
        return List<Map<String, dynamic>>.from(response);
    }

Get Notifications
-----------------

Insert Notification
-------------------

Delete Notification
-------------------

This method deletes a notification using its unique identifier:

``Future<void> deleteNotification(int notificationId) async {}``

* notificationId - The unique identifier of a notification.

.. code-block:: console

    Future<void> deleteNotification(int notificationId) async {
        await _supabase
            .from('notification')
            .delete()
            .eq('notification_id', notificationId);
    }

Dismiss Notification
--------------------

This method dismisses a notification using its unique identifier:

``Future<void> dismissNotification(int notificationId) async {}``

* notificationId - The unique identifier of a notification.

.. code-block:: console

    Future<void> dismissNotification(int notificationId) async {
        await _supabase
            .from('notification')
            .update({'dismissed': true}).eq('notification_id', notificationId);
    }

.. autosummary::
   :toctree: generated

   ExpiryEats