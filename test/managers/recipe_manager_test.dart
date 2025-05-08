import 'package:expiry_eats/recipe.dart';
import 'package:test/test.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';

void main() {
  group("Recipe API Test", () {
    test('Query Chicken', () async {
      RecipeManager manager = RecipeManager();
      List<Recipe> response = await manager.getRecipesByIngredient("Chicken");
      expect(response.length, isNonZero);
    });

    test('Query Beef', () async {
      RecipeManager manager = RecipeManager();
      List<Recipe> response = await manager.getRecipesByIngredient("Beef");
      expect(response.length, isNonZero);
    });

    test('Query Banana', () async {
      RecipeManager manager = RecipeManager();
      List<Recipe> response = await manager.getRecipesByIngredient("Banana");
      expect(response.length, isNonZero);
    });

    test('Query Pork', () async {
      RecipeManager manager = RecipeManager();
      List<Recipe> response = await manager.getRecipesByIngredient("Pork");
      expect(response.length, isNonZero);
    });

    test('Query Blank', () async {
      RecipeManager manager = RecipeManager();
      List<Recipe> response = await manager.getRecipesByIngredient("");
      expect(response.length, isZero);
    });

    test('Query Random', () async {
      RecipeManager manager = RecipeManager();
      List<Recipe> response = await manager.getRecipesByIngredient("abcdefg");
      expect(response.length, isZero);
    });
  });
}