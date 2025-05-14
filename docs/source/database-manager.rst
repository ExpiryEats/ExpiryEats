.. _databaseManager:

Database Manager
================

Overview
--------

Get All Items
-------------

The Database Manager calls to the Supabase Database with the following function:

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

This function simply adds an item to the database using its data:

``Future<void> insertItem(Map<String, dynamic> itemData) async {}``

* itemData - 

.. code-block:: console

    Future<void> insertItem(Map<String, dynamic> itemData) async {
        await _supabase.from('item').insert(itemData);
    }

.. autosummary::
   :toctree: generated

   ExpiryEats