import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expiry_eats/managers/inventory_provider.dart';
import 'package:expiry_eats/managers/recipe_provider.dart';
import 'package:expiry_eats/recipe.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _selectedInventoryItem;
  Recipe? _selectedRecipe;

  @override
  Widget build(BuildContext context) {
    final inventoryItems = context.watch<InventoryProvider>().items;
    final recipes = context.watch<RecipeProvider>().recipes;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Inventory Dropdown Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inventory',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedInventoryItem,
                    items: inventoryItems
                        .map((item) => DropdownMenuItem(
                              value: item.name,
                              child: Text(item.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedInventoryItem = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Inventory Item',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16), // spacing between columns

            // Recipes Dropdown Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recipes',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Recipe>(
                    value: _selectedRecipe,
                    items: recipes
                        .map((recipe) => DropdownMenuItem(
                              value: recipe,
                              child: Text(recipe.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRecipe = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Recipe',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_selectedRecipe != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ingredients:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ..._selectedRecipe!.ingredients
                            .map((ingredient) => Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text('• $ingredient'),
                                )),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
