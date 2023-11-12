import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;


class RecipeDisplayScreen extends StatelessWidget {
  final List<String> selectedIngredients;

  const RecipeDisplayScreen({super.key, required this.selectedIngredients});

  Future<List<Map<String, dynamic>>> loadRecipes(BuildContext context) async {

      final String data = await rootBundle.loadString('assets/recipes.json');
      final List<Map<String, dynamic>> recipes = List<Map<String, dynamic>>.from(json.decode(data));
      return recipes;

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadRecipes(context),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading recipes'));
          } else {
            final List<Map<String, dynamic>> recipes = snapshot.data ?? [];

            // Filter recipes based on selected ingredients
            final List<Map<String, dynamic>> filteredRecipes = recipes.where((recipe) {
              final List<String> recipeIngredients = List<String>.from(recipe['ingredients']);
              return selectedIngredients.every((ingredient) =>
                  recipeIngredients.any((recipeIngredient) =>
                      recipeIngredient.trim().toLowerCase().contains(ingredient.trim().toLowerCase())));
            }).toList();

            final Random random = Random();
            final Map<String, dynamic> generatedRecipe =
            filteredRecipes.isNotEmpty ? filteredRecipes[random.nextInt(filteredRecipes.length)] : {};

            return Scaffold(
              appBar: AppBar(
                title: const Text('Generated Recipe'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display image
                    Image.asset(generatedRecipe['imageUrl'] ?? 'assets/sorry.gif'),

                    const SizedBox(height: 20),
                    // Display title
                    Text(
                      generatedRecipe['title'] ?? 'No Recipe Found',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // Display ingredients
                    Text(
                      'Ingredients: ${generatedRecipe['ingredients']?.join(', ') ?? 'No Ingredients'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Display detailed instructions and prep time
                    Text(
                      'Instructions: ${generatedRecipe['instructions'] ?? 'No Instructions'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Preparation Time: ${generatedRecipe['prepTime'] ?? 'No Prep Time'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
