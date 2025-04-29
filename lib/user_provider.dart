import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:expiry_eats/managers/user_model.dart';
import 'package:expiry_eats/managers/database_manager.dart';

class UserProvider extends ChangeNotifier {
  UserCache? _user;
  UserCache? get user => _user;

  void setUser(UserCache user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUserFromDatabase() async {
    print("Fetching user from database...");

    final email = Supabase.instance.client.auth.currentUser?.email;
    if (email == null) return;

    try {
      final personData = await Supabase.instance.client
          .from('person')
          .select()
          .eq('person_email', email)
          .single();

        final personId = personData['person_id'];

        final dietaryData = await DatabaseService().getPersonDietaryRestrictions(personId);

        final List<String> personDietaryRequirements = dietaryData
        .map((row) => row['dietary_restrictions']['restriction_name'] as String)
        .toList();

      _user = UserCache(
        userId: personData['person_id'],
        firstName: personData['person_first_name'],
        lastName: personData['person_last_name'],
        email: personData['person_email'],
        householdId: personData['household_id'],
        dietaryRequirements: personDietaryRequirements,
      );

      print("User fetched: userId=${_user?.userId}, firstName=${_user?.firstName}, lastName=${_user?.lastName}, email=${_user?.email}, householdId=${_user?.householdId}, dietaryRequirements=${_user?.dietaryRequirements}");
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }
}
