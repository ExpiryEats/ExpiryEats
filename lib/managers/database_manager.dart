import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAllItems(int personId) async {
    final response = await _supabase
        .from('item')
        .select('*')
        .eq('person_id', personId)
        .order('item_name', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertItem(Map<String, dynamic> itemData) async {
    await _supabase.from('item').insert(itemData);
  }

  Future<void> deleteItem(int itemId) async {
    await _supabase.from('item').delete().eq('item_id', itemId);
  }

  Future<List<Map<String, dynamic>>> getPersonDietaryRestrictions(
      int personId) async {
    final response = await _supabase
        .from('person_dietary_restrictions')
        .select('restriction_id, dietary_restrictions(restriction_name)')
        .eq('person_id', personId);
    return List<Map<String, dynamic>>.from(response);
  }

  /* notifications */

  Future<List<Map<String, dynamic>>> getNotifications(int personId,
      {bool? dismissed}) async {
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

  Future<void> deleteNotification(int notificationId) async {
    await _supabase
        .from('notification')
        .delete()
        .eq('notification_id', notificationId);
  }

  Future<void> dismissNotification(int notificationId) async {
    await _supabase
        .from('notification')
        .update({'dismissed': true}).eq('notification_id', notificationId);
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

class UnsplashService {
  static const String accessKey = '-T_kM8VtklcdBy5US1KUs35IuO03DFvh18Jq-ij5Knw';

  static Future<String?> fetchImageUrl(String query) async {
    final url = Uri.parse('https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        return results[0]['urls']['regular'];
      }
    }
    return null;
  }
}