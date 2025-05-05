Recipe API
==========

.. _recipeAPI:

Overview
--------

The **Recipe API** searches for recipes based on specific ingredients in two parts. Firstly, by identifying the ID of the recipes associated with the external API. Secondly, it finds all available information on that recipe with another http request.

Get Recipe By Main Ingredient
-----------------------------

This function will send an http request to the external API and handles a list of recipe IDs it retrieves.

``Future<List<Recipe>> getRecipesByIngredient(String? query) async {}``

.. code-block:: console

   Future<List<Recipe>> getRecipesByIngredient(String? query) async {
      final url = Uri.https('themealdb.com', '/api/json/v1/1/filter.php', {'i': '$query'});

      try {
         final response = await get(url);

         if (response.statusCode == 200) {
            final listResponse = json.decode(response.body);
            return getRecipesById(listResponse["meals"]); # Gets information on each recipe using its ID
         }
      } catch (e) {
         print(e);
      }
   
      return []; # If no recipes, an empty list is returned
   }

.. autosummary::
   :toctree: generated

   lumache