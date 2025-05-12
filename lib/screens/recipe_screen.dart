import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';
import 'package:expiry_eats/screens/find_recipe_screen.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  RecipeScreenState createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  final RecipeManager manager = RecipeManager();
  late List<Recipe> _displayRecipes;

  final List<Recipe> _allRecipes = [
    Recipe(name: "Omelette", imgSrc: "assets/testing_image.jpg", ingredients: ['egg', 'cheese', 'spinach']),
    Recipe(name: "Lasagna", imgSrc: "assets/testing_image.jpg", ingredients: ['pasta', 'beef', 'cheese']),
  ];

  @override
  void initState() {
    super.initState();
    _displayRecipes = _allRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: _allRecipes.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: 'Search Saved Recipes',
                    onChanged: (query) {
                      setState(() => _displayRecipes =
                          RecipeManager.filterRecipes(query.toLowerCase(), _allRecipes));
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FadingEdgeScrollView.fromScrollView(
                      gradientFractionOnStart: 0.2,
                      gradientFractionOnEnd: 0.2,
                      child: ListView(
                        controller: ScrollController(),
                        children: manager.populateRecipes(
                          context,
                          _displayRecipes,
                          MediaQuery.sizeOf(context).width,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(
                child: Text(
                  'No Saved Recipes',
                  style: AppTextStyle.bold(),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FindRecipeScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Find New Recipes'),
        foregroundColor: AppTheme.surface,
        backgroundColor: AppTheme.primary40,
        hoverColor: AppTheme.primary80,
      ),
    );
  }
}