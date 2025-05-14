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

* itemData - The information related to a specific item.

.. code-block:: console

    Future<void> insertItem(Map<String, dynamic> itemData) async {
        await _supabase.from('item').insert(itemData);
    }

Delete An Item
--------------

This method deletes an item in the database using its unique identifier:

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

This method will retrieve all notifications associated with a particular user. If an item is not yet deleted, the notification will be stored as dismissed so that the method does not return it.

``Future<List<Map<String, dynamic>>> getNotifications(int personId, {bool? dismissed}) async {}``

.. code-block:: console

    Future<List<Map<String, dynamic>>> getNotifications(int personId, {bool? dismissed}) async {
        var query = _supabase
            .from('notification')
            .select('*, notification_type(type_name)')
            .eq('person_id', personId);

        if (dismissed != null) {
            query = query.eq('dismissed', dismissed);
        }

        query.order('sent_at', ascending: false);

        final response = await query;
        return List<Map<String, dynamic>>.from(response);
    }

Insert Notification
-------------------

This method inserts notifications into the database with a message relating to a specific item.

``Future<void> insertNotification({required int personId, required String message, required int typeId, int? itemId}) async {}``

.. code-block:: console

    Future<void> insertNotification({
        required int personId,
        required String message,
        required int typeId,
        int? itemId,
    }) async {
        final notificationData = {
            'person_id': personId,
            'message': message,
            'type_id': typeId,
            'sent_at': DateTime.now().toIso8601String(),
            'dismissed': false,
        };

        if (itemId != null) {
            notificationData['item_id'] = itemId;
        }

        await _supabase.from('notification').insert(notificationData);
    }

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

.. _authManager:

Auth Manager
============

Sign Up
-------

This method handles when new users register with the App, creating a new entry for them in the database:

``Future<AuthResponse> signUp(String email, String password, String firstName, String lastName, List<int> selectedRestrictionIds) async {}``

* email - The unique email address of the user.
* password - The user's password.
* firstName - The user's first name.
* lastName - The user's last name.
* selectedRestrictionIds - The ids of the user's selected dietary restrictions.

.. code-block:: console

    Future<AuthResponse> signUp(
        String email,
        String password,
        String firstName,
        String lastName,
        List<int> selectedRestrictionIds,
    ) async {
        # Checks if email and password are valid
        final response = await _supabase.auth.signUp(
            email: email,
            password: password,
        );

        final authId = response.user?.id;

        # If everything is fine the user with be added
        if (authId != null) {
            final insertResult = await _supabase
                .from('person')
                .insert({
                    'person_first_name': firstName,
                    'person_last_name': lastName,
                    'person_email': email,
                })
                .select()
                .single();

            final personId = insertResult['person_id'];

            final inserts = selectedRestrictionIds.map((id) {
                return {
                    'person_id': personId,
                    'restriction_id': id,
                };
            }).toList();

            await _supabase.from('person_dietary_restrictions').insert(inserts);
        }

        return response;
    }

Log In
------

This method passes the user's credentials to the database to log them into the App.

``Future<AuthResponse?> logIn(String email, String password) async {}``

* email - The unique email address of the user.
* password - The user's password.

.. code-block:: console

    Future<AuthResponse?> logIn(String email, String password) async {
        try {
            # Attempts to Sign In the user
            final response = await _supabase.auth.signInWithPassword(
                email: email,
                password: password,
            );
            return response;
        } catch (e) {
            # Handles the error
            print('Login error: $e');
            return null;
        }
    }

Unsplash Service
================

Fetch Image URL
---------------

This method takes the name of an item being added and requests an image source from the API.

``Future<String?> fetchImageUrl(String query) async {}``

* query - The name of the item to search for.

.. code-block:: console

    static Future<String?> fetchImageUrl(String query) async {
        final url = Uri.parse('https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey');

        final response = await http.get(url);

        # Checks if the API returns a good response
        if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final results = data['results'];
            if (results.isNotEmpty) {
                return results[0]['urls']['regular'];
            }
        }
        # Returns nothing if no image is found
        return null;
    }

.. autosummary::
   :toctree: generated

   ExpiryEats