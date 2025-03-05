import 'package:expiry_eats/recipe.dart';

class RecipeManager {
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
}