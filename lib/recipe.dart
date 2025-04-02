class Recipe {
  String name;
  String imgSrc;
  List<String> ingredients;

  Recipe({required this.name, required this.imgSrc, required this.ingredients});

  String formatIngredients() {
    List<String> output = ingredients;
    return output.join(', ');
  }
}