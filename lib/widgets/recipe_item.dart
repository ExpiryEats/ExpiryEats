import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String imgSrc;
  final String name;
  final String ingredients;

  const RecipeItem({
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
            debugPrint("Tap");
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 120,
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    imgSrc,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.bold()
                      ),
                      Text(
                        ingredients,
                        style: AppTextStyle.small()
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}