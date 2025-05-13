import 'package:expiry_eats/managers/recipe_manager.dart';
import 'package:expiry_eats/widgets/bullet_point.dart';
import 'package:flutter/material.dart';
import 'package:expiry_eats/styles.dart';

class RecipeInfoScreen extends StatelessWidget {
  final String recipeName;
  final List<String> recipeItems;
  final String imgSrc;

  final RecipeManager manager = RecipeManager();

  RecipeInfoScreen({
    super.key,
    required this.recipeName,
    required this.recipeItems,
    required this.imgSrc,
  });

  Future<Map<String, dynamic>> fetchRecipeInfo() async {
    return {
      'recipeName': recipeName,
      'recipeItems': recipeItems,
      'imgSrc': imgSrc,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipeName),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: fetchRecipeInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found.'));
              } else {
                final recipeInfo = snapshot.data!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        recipeInfo['imgSrc'],
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        recipeInfo['recipeName'],
                        style: AppTextStyle.bold(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Ingredients',
                        style: AppTextStyle.medium(),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child:
                            BulletPoint(manager.capitaliseItems(recipeItems)),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
