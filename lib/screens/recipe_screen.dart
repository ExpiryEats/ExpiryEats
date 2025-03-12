import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/recipe.dart';
import 'package:expiry_eats/managers/recipe_manager.dart';
import 'package:expiry_eats/widgets/recipe_item.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  RecipeScreenState createState() => RecipeScreenState();
}

class RecipeScreenState extends State<RecipeScreen> {
  final List<Recipe> _allRecipes = [
    Recipe(name: "Test Recipe", imgSrc: "Test", ingredients: ['bacon', 'pasta', 'tomato']),
    Recipe(name: "Omelette", imgSrc: "Test", ingredients: ['egg', 'cheese', 'spinach']),
    Recipe(name: "Lasagna", imgSrc: "Test", ingredients: ['pasta', 'beef', 'cheese']),
  ];

  late List<Recipe> _displayRecipes;

  _populateRecipes(BuildContext context, double width) {
    List<Widget> output = [];
    for (Recipe recipe in _displayRecipes) {
      output.add(RecipeItem(name: recipe.name, imgSrc: recipe.imgSrc,));
    }
    return output;
  }

  @override
  void initState() {
    super.initState();
    _displayRecipes = _allRecipes;
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return _allRecipes.isNotEmpty ? Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search Recipes',
            onChanged: (query) { setState(() => _displayRecipes = RecipeManager.filterRecipes(query.toLowerCase(), _allRecipes)); },
          ),
        ),
        Expanded(
          child: FadingEdgeScrollView.fromScrollView(
            gradientFractionOnStart: 0.2,
            gradientFractionOnEnd: 0.2,
            child: ListView(
              controller: ScrollController(),
              children: _populateRecipes(context, MediaQuery.sizeOf(context).width)
            ),
          ),
        ),
      ],
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