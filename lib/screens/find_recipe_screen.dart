import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class FindRecipeScreen extends StatefulWidget {
  const FindRecipeScreen({super.key});

  @override
  FindRecipeScreenState createState() => FindRecipeScreenState();
}

class FindRecipeScreenState extends State<FindRecipeScreen> {
  final RecipeManager manager = RecipeManager();
  late List<Recipe> _displayRecipes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _displayRecipes = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _searchRecipes(String query) async {
    setState(() => _isLoading = true);
    _displayRecipes = await manager.getRecipesByIngredient(query);
    setState(() => _isLoading = false);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SearchBar(
              leading: const Icon(Icons.search),
              hintText: 'Search New Recipes',
              onSubmitted: _searchRecipes,
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_displayRecipes.isNotEmpty)
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
              )
            else
              Expanded(
                child: Center(
                  child: Text(
                    'Search For Recipes',
                    style: AppTextStyle.bold(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
