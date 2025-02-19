import 'package:expiry_eats/styles.dart';
import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String imgSrc;
  final String name;

  const RecipeItem({
    super.key,
    required this.name,
    required this.imgSrc
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                width: 120,
                height: 120,
                child: Stack()// Image.network(imgSrc),
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
                      "Items",
                      style: AppTextStyle.small()
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}