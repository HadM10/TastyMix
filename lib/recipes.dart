import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipeDisplayScreen extends StatelessWidget {
  final List<String> selectedIngredients;

  const RecipeDisplayScreen({Key? key, required this.selectedIngredients}) : super(key: key);

  Future<List<Map<String, dynamic>>> loadRecipes(BuildContext context) async {
    final Uri url = Uri.parse('https://tastymix.000webhostapp.com/get_recipes.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> allRecipes = List<Map<String, dynamic>>.from(json.decode(response.body));

        // Filter recipes based on selected ingredients
        final List<Map<String, dynamic>> filteredRecipes = allRecipes.where((recipe) {
          final List<String> recipeIngredients = (recipe['ingredients'] as String)
              .split(',')
              .map((ingredient) => ingredient.replaceAll('"', '').trim())
              .toList();
          return selectedIngredients.every((ingredient) =>
              recipeIngredients.any((recipeIngredient) =>
                  recipeIngredient.trim().toLowerCase().contains(ingredient.trim().toLowerCase())));
        }).toList();

        return filteredRecipes;
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load recipes');
    }
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
            final Random random = Random();
            final Map<String, dynamic> generatedRecipe =
            recipes.isNotEmpty ? recipes[random.nextInt(recipes.length)] : {};

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
                      'Ingredients: ${(generatedRecipe['ingredients'] as String).replaceAll(', ', ', ')}' ?? 'No Ingredients',
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
