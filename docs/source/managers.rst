Recipe Manager
================

.. _recipeManager:

Overview
--------

The **Recipe Manager** handles filtering recipes, formatting UI elements and interactions with the Recipe API.

Filtering Recipes
-----------------

To implement a functional search feature, the Recipe Manager has a filterRecipes function:
``filterRecipes(String? searchTerm, List<Recipe> allRecipes) -> List<Recipe>``

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
This function handles converting the internal definition of a function into a Widget for the UI.
``populateRecipes(BuildContext context, List<Recipe> displayRecipes)``

* context - The BuildContext for the current screen.
* displayRecipes - A list of all the recipes to convert to Widgets.

.. autosummary::
   :toctree: generated

   lumache