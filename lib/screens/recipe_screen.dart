import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/colors.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/widgets/recipe_item.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  RecipeScreenState createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  final List<Recipe> _recipes = [
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
    Recipe(name: "Recipe Name", imgSrc: "Test"),
  ];

  _populateRecipes(BuildContext context, double width) {
    List<RecipeItem> output = [];
    for (Recipe recipe in _recipes) {
      output.add(RecipeItem(name: recipe.name, imgSrc: recipe.imgSrc,));
    }
    return output;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _recipes.isNotEmpty ? Stack(
      children: [
        FadingEdgeScrollView.fromScrollView(
          gradientFractionOnStart: 0.2,
          gradientFractionOnEnd: 0.2,
          child: ListView(
            controller: ScrollController(),
            children: _populateRecipes(context, MediaQuery.sizeOf(context).width)
          ),
        ),
      ]
    ) : Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment(0.0, 0.0),
          child: Text(
            'No Saved Recipes',
            style: AppTextStyle.bold(),
          ),
        ),
      ),
    );
  }
}