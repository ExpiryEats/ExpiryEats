.. _cacheProvider:

Cache Provider
==============

Overview
--------

Fetch User Data
---------------

The manaager calls to the Supabase Database with the following method:

``final email = Supabase.instance.client.auth.currentUser?.email;``

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
    }


