MANAGERS
========

- Recipe Manager
================

Overview
--------

The **Recipe Manager** handles filtering recipes, formatting UI elements and interactions with the Recipe API.

Filtering Recipes
-----------------

To implement a functional search feature, the Recipe Manager has a ``filterRecipes(String? searchTerm, List<Recipe> allRecipes)`` function:

* searchTerm - The string to search for
* allRecipes - A list of all the recipes to search from

For example:



.. autosummary::
   :toctree: generated

   lumache