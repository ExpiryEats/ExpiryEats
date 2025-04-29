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

  @override
  void initState() {
    super.initState();
    _displayRecipes = [];
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for Recipes"),
        backgroundColor: AppTheme.primary40,
        foregroundColor: AppTheme.surface,
      ),
      backgroundColor: AppTheme.surface,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: 'Search New Recipes',
              onSubmitted: (query) async {
                RecipeManager manager = RecipeManager();
                _displayRecipes = await manager.getRecipesByIngredient(query);
                setState(() {});
              },
            ),
          ),
          _displayRecipes.isNotEmpty ? Expanded(
            child: FadingEdgeScrollView.fromScrollView(
              gradientFractionOnStart: 0.2,
              gradientFractionOnEnd: 0.2,
              child: ListView(
                controller: ScrollController(),
                children: manager.populateRecipes(context, _displayRecipes, MediaQuery.sizeOf(context).width)
              ),
            ),
          ) : Align(
            alignment: Alignment.center,
            child: Expanded(
              child: Align(
                alignment: Alignment(0.0, 0.0),
                child: Text(
                  'Search For Recipes',
                  style: AppTextStyle.bold(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}