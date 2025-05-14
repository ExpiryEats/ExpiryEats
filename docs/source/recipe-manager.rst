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