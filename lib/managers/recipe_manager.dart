import 'package:expiry_eats/recipe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RecipeManager {
  get http => null;

  static List<Recipe> filterRecipes(String? searchTerm, List<Recipe> allRecipes) {
    List<Recipe> output;
    if (searchTerm == null || searchTerm == '') {
      output = allRecipes;
    } else {
      output = allRecipes.where((recipe) =>
        recipe.name.toLowerCase().contains(searchTerm) ||
        recipe.ingredients.any((ingredient) => ingredient.toLowerCase().contains(searchTerm)
      )).toList();
    }

    return output;
  }

  Future<void> getRecipes(String? query) async {
    final url = Uri.https('api.api-ninjas.com', '/v1/recipe', {'query': '$query'});
    print('URL: $url');

    final response = await get(url, headers: {'X-Api-Key': 'd0f8a7SbXICIh8hFk8Znbw==sDU1CMcTio7OGpwy'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    }
    // try {
    //   final response = await get(url, headers: {'X-Api-Key': 'd0f8a7SbXICIh8hFk8Znbw==sDU1CMcTio7OGpwy'});
    //   print(response.statusCode);
    //   if (response.statusCode == 200) {
    //     print(response.body);
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
}