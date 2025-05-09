import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllItems(int personId) async {
    try {
      debugPrint('[getAllItems] Fetching items for personId: $personId');

      final response = await _supabase
          .from('item')
          .select('*')
          .eq('person_id', personId)
          .order('item_name', ascending: true);

      debugPrint('[getAllItems] Response received: ${response.length} items');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[getAllItems] ERROR: $e');
      return [];
    }
  }

  Future<void> insertItem(Map<String, dynamic> itemData) async {
    await _supabase.from('item').insert(itemData);
  }

  Future<List<Map<String, dynamic>>> getPersonDietaryRestrictions(
      int personId) async {
    final response = await _supabase
        .from('person_dietary_restrictions')
        .select('restriction_id, dietary_restrictions(restriction_name)')
        .eq('person_id', personId);
    return List<Map<String, dynamic>>.from(response);
  }
}

class AuthManager {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    List<int> selectedRestrictionIds,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final authId = response.user?.id;

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

  Future<AuthResponse?> logIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }
}
