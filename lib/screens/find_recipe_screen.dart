import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/managers/cache_provider.dart';
import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';
import 'package:expiry_eats/widgets/recipe_item.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:provider/provider.dart';

class FindRecipeScreen extends StatefulWidget {
  const FindRecipeScreen({super.key});

  @override
  FindRecipeScreenState createState() => FindRecipeScreenState();
}

class FindRecipeScreenState extends State<FindRecipeScreen> {
  final RecipeManager manager = RecipeManager();
  late List<Recipe> _displayRecipes;

  @override
  void initState() {
    super.initState();
    _displayRecipes = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search for Recipes"),
        backgroundColor: AppTheme.primary40,
        foregroundColor: AppTheme.surface,
      ),
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: 'Search New Recipes',
              onSubmitted: (query) async {
                final cache =
                    Provider.of<CacheProvider>(context, listen: false).cache;

                List<Recipe> results =
                    await manager.getRecipesByIngredient(query);

                _displayRecipes = manager.filterRecipesByDiet(
                    results, cache.dietaryRequirements);

                setState(() {});
              },
            ),
          ),
          _displayRecipes.isNotEmpty
              ? Expanded(
                  child: FadingEdgeScrollView.fromScrollView(
                    gradientFractionOnStart: 0.2,
                    gradientFractionOnEnd: 0.2,
                    child: ListView(
                      controller: ScrollController(),
                      children: _displayRecipes
                          .map(
                            (recipe) => RecipeItem(
                              name: recipe.name,
                              imgSrc: recipe.imgSrc,
                              ingredients: recipe.ingredients,
                              showSaveButton: true,
                              onSave: () => Navigator.pop(context, recipe),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : Expanded(
                  child: Center(
                    child: Text(
                      'Search For Recipes',
                      style: AppTextStyle.bold(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}