import 'package:flutter_test/flutter_test.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';

void main() {
  RecipeManager manager = RecipeManager();

  group('Recipe Manager Filter Recipes', () {
    final recipes = [
      Recipe(name: 'Pasta', imgSrc: '', ingredients: ['pasta', 'tomato']),
      Recipe(name: 'Fruit Salad', imgSrc: '', ingredients: ['apple', 'banana']),
      Recipe(name: 'Omelette', imgSrc: '', ingredients: ['egg', 'cheese']),
    ];

    test('filterRecipes returns matching recipes', () {
      final result = manager.filterRecipes('pasta', recipes);

      expect(result.length, 1);
      expect(result.first.name, 'Pasta');
    });

    test('filterRecipes is case-insensitive', () {
      final result = manager.filterRecipes('OMeLette', recipes);

      expect(result.length, 1);
      expect(result.first.name, 'Omelette');
    });

    test('filterRecipes returns empty list when no match', () {
      final result = manager.filterRecipes('bacon', recipes);

      expect(result, isEmpty);
    });
  });

  group("Recipe API Test", () {
    test('Query Chicken', () async {
      List<Recipe> response = await manager.getRecipesByIngredient("Chicken");
      expect(response.length, isNonZero);
    });

    test('Query Beef', () async {
      List<Recipe> response = await manager.getRecipesByIngredient("Beef");
      expect(response.length, isNonZero);
    });

    test('Query Banana', () async {
      List<Recipe> response = await manager.getRecipesByIngredient("Banana");
      expect(response.length, isNonZero);
    });

    test('Query Pork', () async {
      List<Recipe> response = await manager.getRecipesByIngredient("Pork");
      expect(response.length, isNonZero);
    });

    test('Query Blank', () async {
      List<Recipe> response = await manager.getRecipesByIngredient("");
      expect(response.length, isZero);
    });

    test('Query Random', () async {
      List<Recipe> response = await manager.getRecipesByIngredient("abcdefg");
      expect(response.length, isZero);
    });
  });
}