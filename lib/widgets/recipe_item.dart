import 'package:expiry_eats/managers/recipe_manager.dart';
import 'package:expiry_eats/screens/recipe_info_screen.dart';
import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String imgSrc;
  final String name;
  final List<String> ingredients;

  final RecipeManager manager = RecipeManager();

  RecipeItem({
    super.key,
    required this.name,
    required this.imgSrc,
    required this.ingredients
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecipeInfoScreen(
                recipeName: name,
                recipeItems: ingredients,
                imgSrc: imgSrc,
              ))
            );
            debugPrint('Item tapped: $name');
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  height: MediaQuery.of(context).size.height,
                  child: Image.network(
                    imgSrc,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: AppTextStyle.bold()
                        ),
                        Text(
                          "Ingredients",
                          style: AppTextStyle.medium(),
                        ),
                        Text(
                          manager.formatItems(manager.capitaliseItems(ingredients)),
                          style: AppTextStyle.small(),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}