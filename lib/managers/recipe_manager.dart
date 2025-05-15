import 'dart:convert';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/widgets/recipe_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RecipeManager {
  get http => null;

  static List<Recipe> filterRecipes(
      String? searchTerm, List<Recipe> allRecipes) {
    List<Recipe> output;
    if (searchTerm == null || searchTerm == '') {
      output = allRecipes;
    } else {
      output = allRecipes
          .where((recipe) =>
              recipe.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
              recipe.ingredients.any((ingredient) =>
                  ingredient.toLowerCase().contains(searchTerm.toLowerCase())))
          .toList();
    }

    return output;
  }

  List<Recipe> filterRecipesByDiet(
    List<Recipe> allRecipes,
    List<String> userDietaryRestrictions,
  ) {
    return allRecipes.where((recipe) {
      return !recipe.ingredients.any((ingredient) =>
          userDietaryRestrictions.any((restriction) =>
              ingredient.toLowerCase().contains(restriction.toLowerCase())));
    }).toList();
  }

  List<Widget> populateRecipes(
      BuildContext context, List<Recipe> displayRecipes) {
    List<Widget> output = [];
    for (Recipe recipe in displayRecipes) {
      output.add(RecipeItem(
        name: recipe.name,
        imgSrc: recipe.imgSrc,
        ingredients: recipe.ingredients,
      ));
    }
    return output;
  }

  Future<List<Recipe>> getRecipesByIngredient(String? query) async {
    if (query == '') {
      return [];
    }

    final url = Uri.https(
        'themealdb.com', '/api/json/v1/1/filter.php', {'i': '$query'});

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final listResponse = json.decode(response.body);
        return getRecipesById(listResponse["meals"]);
      }
    } catch (e) {
      debugPrint('Fetch Error: $e');
    }

    return [];
  }

  Future<List<Recipe>> getRecipesById(List<dynamic> meals) async {
    List<Recipe> output = [];
    for (final recipe in meals) {
      final url = Uri.https('themealdb.com', '/api/json/v1/1/lookup.php',
          {'i': recipe["idMeal"]!});
      try {
        final response = await get(url);
        if (response.statusCode == 200) {
          final fullRecipe = json.decode(response.body)["meals"][0];
          List<String> ingredients = [];
          for (int i = 1; i <= 20; i++) {
            if (fullRecipe["strIngredient$i"] == "" ||
                fullRecipe["strIngredient$i"] == null) {
              break;
            } else {
              ingredients.add(fullRecipe["strIngredient$i"]);
            }
          }
          output.add(Recipe(
              name: recipe["strMeal"]!,
              imgSrc: recipe["strMealThumb"]!,
              ingredients: ingredients));
        }
      } catch (e) {
        debugPrint('Fetch Error $e');
      }
    }
    return output;
  }

  String formatItems(List<String> ingredients) => ingredients.join(', ');

  List<String> capitaliseItems(List<String> ingredients) {
    List<String> output = [];

    for (String item in ingredients) {
      String firstLetter = item.substring(0, 1);
      String rest = item.substring(1);
      output.add(firstLetter.toUpperCase() + rest);
    }

    return output;
  }
}