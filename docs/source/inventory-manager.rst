Recipe Manager
================

.. _recipeManager:

Overview
--------

The **Inventory Manager** handles filtering recipes, formatting UI elements and interactions with the Recipe API.

Filtering Inventory
-------------------

To implement a functional search feature, the Inventory Manager has a filterInventory function:

``List<Item> filterInventory(String? searchTerm, List<Item> allItems) {}``

* searchTerm - The string to search for.
* allItems - A list of all the items to search from.

For example:

.. code-block:: console

   InventoryManager manager = InventoryManager();

   List<Recipe> recipes = [
      Recipe(name: "Omelette", ingredients: ['egg', 'cheese', 'spinach']),
      Recipe(name: "Lasagna", ingredients: ['pasta', 'beef', 'cheese']),
      Recipe(name: "Mashed Potatoes", ingredients: ['potato', 'chicken', 'herbs'])
   ];

   String query = "chicken";
   output = manager.filterRecipes(query, recipes);

>>> output
[Recipe(name: "Mashed Potatoes", ingredients: ['potato', 'chicken', 'herbs'])]

.. autosummary::
   :toctree: generated

   lumache