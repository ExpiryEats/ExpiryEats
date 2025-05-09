import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expiry_eats/managers/cache_manager.dart';
import 'package:expiry_eats/managers/database_manager.dart';

class CacheProvider extends ChangeNotifier {
  CacheManager _cache = CacheManager();
  CacheManager get cache => _cache;

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

  Future<void> fetchUserFromDatabase() async {
    debugPrint("Fetching user data...");
    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email == null) return;

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

      debugPrint(
          "User cached: ID=${_cache.userId}, Name=${_cache.firstName} ${_cache.lastName}, Email=${_cache.email}, Household=${_cache.householdId}, Dietary=${_cache.dietaryRequirements.join(', ')}");
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user data: $e');
    }
  }

  Future<void> fetchReferenceData() async {
    debugPrint("Fetching reference data...");
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

      _cache = _cache.copyWith(
        categories: List<Map<String, dynamic>>.from(categoriesResponse),
        storageTypes: List<Map<String, dynamic>>.from(storageTypesResponse),
        dietaryRestrictionTypes:
            List<Map<String, dynamic>>.from(dietaryRestrictionTypesResponse),
      );

      // Debug print
      debugPrint("Categories:");
      for (var category in _cache.categories) {
        debugPrint(
            " - ID: ${category['category_id']}  Name: ${category['category_name']}");
      }

      debugPrint("Storage Types:");
      for (var storageType in _cache.storageTypes) {
        debugPrint(
            " - ID: ${storageType['storage_type_id']}  Name: ${storageType['type_name']}");
      }

      debugPrint("Dietary Restriction Types:");
      for (var dietaryRestrictionType in _cache.dietaryRestrictionTypes) {
        debugPrint(
            " - ID: ${dietaryRestrictionType['restriction_id']}  Name: ${dietaryRestrictionType['restriction_name']}");
      }

      debugPrint("Reference data cached");
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching reference data: $e');
    }
  }
}
