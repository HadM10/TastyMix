import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryRecipesPage(category: 'savory'),
                  ),
                );
              },
              child: const Text('Savory'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryRecipesPage(category: 'sweet'),
                  ),
                );
              },
              child: const Text('Sweet'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryRecipesPage extends StatelessWidget {
  final String category;

  const CategoryRecipesPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadRecipes(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final List<Map<String, dynamic>> recipes = snapshot.data!;

            // Filter recipes based on category (savory or sweet)
            final List<Map<String, dynamic>> categoryRecipes = recipes.where((recipe) {
              return recipe['category'] == category;
            }).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text(category == 'savory' ? 'Savory Recipes' : 'Sweet Recipes'),
              ),


              body: ListView.builder(
                itemCount: categoryRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = categoryRecipes[index];
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
                    titleAlignment: ListTileTitleAlignment.center,
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
          } else {
            return const Center(child: Text('No data available'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> loadRecipes() async {
    final String data = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.cast<Map<String, dynamic>>();
  }
}

class RecipeDisplayScreen extends StatelessWidget {
  final List<String> selectedIngredients;
  final Map<String, dynamic> recipe;

  const RecipeDisplayScreen({super.key, required this.selectedIngredients, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title']),
      ),
      body:  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(recipe['imageUrl'] ?? 'assets/sorry.gif'),
            const SizedBox(height: 20),
            Text(recipe['title'] ?? 'No title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 20),
            Text('Ingredients: ${recipe['ingredients']?.join(', ') ?? 'No Ingredients'}',
              style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 20),
            Text('Instructions: ${recipe['instructions'] ?? 'No Instructions'}',
              style: const TextStyle(fontSize: 16),),
            const SizedBox(height: 20),
            Text('Preparation Time: ${recipe['prepTime'] ?? 'No Prep Time'}',
              style: const TextStyle(fontSize: 16),),
          ],
        ),
      ),
    );
  }
}
