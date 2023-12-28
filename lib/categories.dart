import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
              ),
              onPressed: () {
                navigateToCategory(context, 'savory');
              },
              child: const Text('Savory'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
              ),
              onPressed: () {
                navigateToCategory(context, 'sweet');
              },
              child: const Text('Sweet'),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToCategory(BuildContext context, String category) async {
    final response = await http.get(Uri.parse('https://tastymix.000webhostapp.com/get_recipes_by_category.php?category=$category'));

    if (response.statusCode == 200) {
      List<dynamic> decodedData = json.decode(response.body);
      // You can navigate to the next page passing decodedData or use it as required.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryRecipesPage(category: category, recipes: decodedData),
        ),
      );
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}

class CategoryRecipesPage extends StatelessWidget {
  final String category;
  final List<dynamic> recipes;

  const CategoryRecipesPage({Key? key, required this.category, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use recipes data to display recipes for the given category
    return Scaffold(
      appBar: AppBar(
        title: Text(category == 'savory' ? 'Savory Recipes' : 'Sweet Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.red[800], // Set your preferred background color here
              borderRadius: BorderRadius.circular(10), // Optional: Add rounded corners
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            child: ListTile(
              title: Text(recipe['title']),
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDisplayScreen(
                      selectedIngredients: const [], // Pass an empty list as there's no ingredient selection
                      recipe: recipe, // Pass the selected recipe to RecipeDisplayScreen
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class RecipeDisplayScreen extends StatelessWidget {
  final List<String> selectedIngredients;
  final Map<String, dynamic> recipe;

  const RecipeDisplayScreen({Key? key, required this.selectedIngredients, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title']),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(recipe['imageUrl'] ?? 'assets/sorry.gif'),
            const SizedBox(height: 20),
            Text(
              recipe['title'] ?? 'No title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Ingredients: ${(recipe['ingredients'] as String).replaceAll(', ', ', ')}' ?? 'No Ingredients',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Instructions: ${recipe['instructions'] ?? 'No Instructions'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Preparation Time: ${recipe['prepTime'] ?? 'No Prep Time'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
