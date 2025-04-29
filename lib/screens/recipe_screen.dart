import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/widgets/recipe_item.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/recipe_provider.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  RecipeScreenState createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RecipeProvider>(context, listen: false);
    if (provider.recipes.isEmpty) {
      provider.addRecipe(Recipe(
        name: "Test Recipe",
        imgSrc: "assets/testing_image.jpg",
        ingredients: ['bacon', 'pasta', 'tomato'],
      ));
      provider.addRecipe(Recipe(
        name: "Omelette",
        imgSrc: "assets/testing_image.jpg",
        ingredients: ['egg', 'cheese', 'spinach'],
      ));
      provider.addRecipe(Recipe(
        name: "Lasagna",
        imgSrc: "assets/testing_image.jpg",
        ingredients: ['pasta', 'beef', 'cheese'],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);
    final allRecipes = provider.recipes;
    final displayRecipes = _searchTerm.isEmpty
        ? allRecipes
        : allRecipes.where((r) {
            final term = _searchTerm.toLowerCase();
            return r.name.toLowerCase().contains(term) ||
                r.ingredients.any((ing) => ing.toLowerCase().contains(term));
          }).toList();

    return displayRecipes.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: 'Search Recipes',
                  onChanged: (query) => setState(() => _searchTerm = query),
                ),
              ),
              Expanded(
                child: FadingEdgeScrollView.fromScrollView(
                  gradientFractionOnStart: 0.2,
                  gradientFractionOnEnd: 0.2,
                  child: ListView(
                    controller: ScrollController(),
                    children: displayRecipes
                        .map((recipe) => RecipeItem(
                              name: recipe.name,
                              imgSrc: recipe.imgSrc,
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              'No Saved Recipes',
              style: AppTextStyle.bold(),
            ),
          );
  }
}
