Recipe Manager
================

.. _recipeManager:

Overview
--------

The **Recipe Manager** handles filtering recipes, formatting UI elements and interactions with the Recipe API.

Filtering Recipes
-----------------

To implement a functional search feature, the Recipe Manager has a filterRecipes function:
``filterRecipes(String? searchTerm, List<Recipe> allRecipes)``

* searchTerm - The string to search for.
* allRecipes - A list of all the recipes to search from.

For example:

.. code-block:: console

   RecipeManager manager = RecipeManager();
   List<Recipe> recipes = [
    Recipe(),
    Recipe(),
    Recipe()
   ];
   String query = "Chicken";
   output = manager.filterRecipes(query, recipes);

>>> output
[]
   

.. autosummary::
   :toctree: generated

   lumache