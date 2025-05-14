.. _recipeAPI:

Recipe API
==========

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
            # Gets information on each recipe using its ID
            return getRecipesById(listResponse["meals"]);
         }
      } catch (e) {
         print(e);
      }
   
      # If no recipes, an empty list is returned
      return [];
   }

Get Recipe By ID
----------------

This is a helper function that finds information on each recipe given to it by the previous function.

``Future<List<Recipe>> getRecipesById(List<dynamic> meals) async {}``

.. code-block:: console

   Future<List<Recipe>> getRecipesById(List<dynamic> meals) async {
      List<Recipe> output = [];
      for (final recipe in meals) {
         final url = Uri.https('themealdb.com', '/api/json/v1/1/lookup.php', {'i': recipe["idMeal"]!});
         try {
            final response = await get(url);
            if (response.statusCode == 200) {
               final fullRecipe = json.decode(response.body)["meals"][0];
               List<String> ingredients = [];
               for (int i = 1; i <= 20; i++) {
                  if (fullRecipe["strIngredient$i"] == "" || fullRecipe["strIngredient$i"] == null) {
                     break;
                  } else {
                     ingredients.add(fullRecipe["strIngredient$i"]);
                  }
               }
               output.add(Recipe(name: recipe["strMeal"]!, imgSrc: recipe["strMealThumb"]!, ingredients: ingredients));
            }
         } catch (e) {
            print(e);
         }
      }
      return output;
   }

.. autosummary::
   :toctree: generated

   ExpiryEats