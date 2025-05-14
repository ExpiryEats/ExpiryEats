.. _cacheManager:

Cache Provider
================

Overview
--------

Fetch User Data
--------------

The manaager calls to the Supabase Database with the following method:

``Future<void> fetchUserFromDatabase() async {}``

Using the user's email, the manager retrieves the user's data which includes their ID, first name, last name, email, household ID, and dietary requirements, via this method:

.. code-block:: console

    try {
      final personData = await Supabase.instance.client
          .from('person')
          .select()
          .eq('person_email', email)
          .single();

      final personId = personData['person_id'];

      final dietaryData =
          await DatabaseService().getPersonDietaryRestrictions(personId);

      final List<String> personDietaryRequirements = dietaryData
          .map((row) =>
              row['dietary_restrictions']['restriction_name'] as String)
          .toList();

It is then cached and saved in the database, it also uupdates the user's data using notify listeners:

.. code-block:: console

    _cache = _cache.copyWith(
        userId: personData['person_id'],
        firstName: personData['person_first_name'],
        lastName: personData['person_last_name'],
        email: personData['person_email'],
        householdId: personData['household_id'],
        dietaryRequirements: personDietaryRequirements,
      );

      print(
          "User cached: ID=${_cache.userId}, Name=${_cache.firstName} ${_cache.lastName}, Email=${_cache.email}, Household=${_cache.householdId}, Dietary=${_cache.dietaryRequirements.join(', ')}");
      notifyListeners();
    } catch (e) {
        #handle error
      print('Error fetching user data: $e'); 
    }
  }

Setting User Data
----------------

This method is used to set the user's data and notifies any widgets, screeens or pages that require it:

.. code-block:: console

     void setUserData({
    int? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? householdId,
    List<String>? dietaryRequirements,
  }) {
    _cache = _cache.copyWith(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      householdId: householdId,
      dietaryRequirements: dietaryRequirements,
    );
    notifyListeners();
  }

*userId* - The unique identifier of an individual user.
*email* - The email address of the user.
*household_id - The unique identifier of the user(s) household.


Fetch Reference Data
-------------------

The Cache Manager fetches reference data from the database using the following method:

``Future<void> fetchReferenceData() async {}``

This method retrieves the list of dietary restrictions and item types from the database and caches them. It also updates the reference data using notify listeners:

.. code-block:: console

    try {
      final categoriesResponse = await Supabase.instance.client
          .from('category')
          .select('category_id, category_name');

      final storageTypesResponse = await Supabase.instance.client
          .from('storage_type')
          .select('storage_type_id, type_name');

      final dietaryRestrictionTypesResponse = await Supabase.instance.client
          .from('dietary_restrictions')
          .select('restriction_id, restriction_name');


Afterwards the data is cached and saved in the database, it also updates the reference data using notify listeners:
.. code-block:: console

      _cache = _cache.copyWith(
        categories: List<Map<String, dynamic>>.from(categoriesResponse),
        storageTypes: List<Map<String, dynamic>>.from(storageTypesResponse),
        dietaryRestrictionTypes: List<Map<String, dynamic>>.from(dietaryRestrictionTypesResponse),
      );


Setting Reference Data
------------------

This method uses local storage to set the reference data input by the user and notifies any widgets, screens or pages that require it:

.. code-block:: console

    void setReferenceData({
    List<Map<String, dynamic>>? categories,
    List<Map<String, dynamic>>? storageTypes,
    List<Map<String, dynamic>>? dietaryRestrictionTypes,
  }) {
    _cache = _cache.copyWith(
      categories: categories,
      storageTypes: storageTypes,
      dietaryRestrictionTypes: dietaryRestrictionTypes,
    );
    notifyListeners();
  }