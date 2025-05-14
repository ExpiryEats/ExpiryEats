import 'package:flutter_test/flutter_test.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';

void main() {
  group('RecipeManager', () {
    final recipes = [
      Recipe(name: 'Pasta', imgSrc: '', ingredients: ['pasta', 'tomato']),
      Recipe(name: 'Fruit Salad', imgSrc: '', ingredients: ['apple', 'banana']),
      Recipe(name: 'Omelette', imgSrc: '', ingredients: ['egg', 'cheese']),
    ];

    test('filterRecipes returns matching recipes', () {
      final result = RecipeManager.filterRecipes('pasta', recipes);

      expect(result.length, 1);
      expect(result.first.name, 'Pasta');
    });

    test('filterRecipes is case-insensitive', () {
      final result = RecipeManager.filterRecipes('OMeLette', recipes);

      expect(result.length, 1);
      expect(result.first.name, 'Omelette');
    });

    test('filterRecipes returns empty list when no match', () {
      final result = RecipeManager.filterRecipes('bacon', recipes);

      expect(result, isEmpty);
    });
  });
}