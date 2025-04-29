import 'package:flutter/foundation.dart';
import 'package:expiry_eats/recipe.dart';

class RecipeProvider with ChangeNotifier {
  final List<Recipe> _recipes = [];

  List<Recipe> get recipes => List.unmodifiable(_recipes);

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(Recipe recipe) {
    _recipes.remove(recipe);
    notifyListeners();
  }
}
