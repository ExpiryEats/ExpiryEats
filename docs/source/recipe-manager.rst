.. _recipeManager:

Recipe Manager
================

Overview
--------

The **Recipe Manager** handles filtering recipes, formatting UI elements and interactions with the Recipe API.

Filtering Recipes
-----------------

To implement a functional search feature, the Recipe Manager has a filterRecipes function:

``List<Recipe> filterRecipes(String? searchTerm, List<Recipe> allRecipes) {}``

* searchTerm - The string to search for.
* allRecipes - A list of all the recipes to search from.

For example:

.. code-block:: console

   RecipeManager manager = RecipeManager();

   List<Recipe> recipes = [
      Recipe(name: "Omelette", ingredients: ['egg', 'cheese', 'spinach']),
      Recipe(name: "Lasagna", ingredients: ['pasta', 'beef', 'cheese']),
      Recipe(name: "Mashed Potatoes", ingredients: ['potato', 'chicken', 'herbs'])
   ];

   String query = "chicken";
   output = manager.filterRecipes(query, recipes);

>>> output
[Recipe(name: "Mashed Potatoes", ingredients: ['potato', 'chicken', 'herbs'])]

Populate Recipes
----------------
This function handles converting the internal definition of a recipe into a Widget for the UI.

``List<Widget> populateRecipes(BuildContext context, List<Recipe> displayRecipes) {}``

* context - The BuildContext for the current screen.
* displayRecipes - A list of all the recipes to convert to Widgets.

For example:

.. code-block:: console

   RecipeManager manager = RecipeManager();

   List<Recipe> recipes = [
      Recipe(name: "Omelette", ingredients: ['egg', 'cheese', 'spinach'])
   ];

   output = manager.populateRecipes(context, recipes);

>>> output
[RecipeItem(name: "Mashed Potatoes", ingredients: ['potato', 'chicken', 'herbs'])]

Filter via Dietary Restrictions
-----------------------------

this method filters the items in the database using the dietary restrictions set by the user:

.. code-block:: console

    List<Recipe> filterRecipesByDiet(
    List<Recipe> allRecipes,
    List<String> userDietaryRestrictions,
  ) {
    return allRecipes.where((recipe) {
      return !recipe.ingredients.any((ingredient) =>
          userDietaryRestrictions.any((restriction) =>
              ingredient.toLowerCase().contains(restriction.toLowerCase())));
    }).toList();
  }

  If a recipe contains any of the dietary restrictions, it will be filtered out.
  For example: User has a restriction of "egg" and the recipe contains "egg", it will be filtered out.

.. code-block:: console
    >>> Before filtering:
      [Recipe(name: "Omelette", ingredients: ['egg', 'cheese', 'spinach']),
      Recipe(name: "Lasagna", ingredients: ['pasta', 'beef', 'cheese']),
      Recipe(name: "Mashed Potatoes", ingredients: ['potato', 'chicken', 'herbs'])]

      >>> After filtering:
      [Recipe(name: "Lasagna", ingredients: ['pasta', 'beef', 'cheese']),

Adding recipe to the database
--------------------------------




Format Items
------------
This function takes each ingredient of a recipe and joins them together into a single string.

``String formatItems(List<String> ingredients) {}``

* ingredients - A list of all the ingredients in a recipe.

For example:

.. code-block:: console

   RecipeManager manager = RecipeManager();

   List<String> ingredients = ['egg', 'cheese', 'spinach'];

   output = manager.formatItems(ingredients);

>>> output
"egg, cheese, spinach"

Capitalise Items
---------------
This function takes each ingredient of a recipe and capitalises it.

``List<String> capitaliseItems(List<String> ingredients) {}``

* ingredients - A list of all the ingredients in a recipe.

For example:

.. code-block:: console

   RecipeManager manager = RecipeManager();

   List<String> ingredients = ['egg', 'cheese', 'spinach'];

   output = manager.capitaliseItems(ingredients);

>>> output
['Egg', 'Cheese', 'Spinach']

.. autosummary::
   :toctree: generated

   ExpiryEats