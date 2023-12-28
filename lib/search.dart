import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];

  Future<void> searchRecipes(String query) async {
    final url = Uri.parse('https://tastymix.000webhostapp.com/search.php?searchQuery=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  void displayRecipeDetails(dynamic recipe) {
    // Navigate to a new page to display the details of the selected recipe
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDisplayScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Recipes...',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                // Call searchRecipes when the user enters text in the search field
                searchRecipes(value);
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  // Display buttons for each search result recipe
                  return ElevatedButton(
                    onPressed: () {
                      displayRecipeDetails(searchResults[index]);
                    },
                    child: Text(searchResults[index]['title']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}


class RecipeDisplayScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDisplayScreen({Key? key, required this.recipe}) : super(key: key);

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
            Image.asset(
              recipe['imageUrl'] ?? 'assets/sorry.gif',
              height: 200, // Adjust the height of the image as needed
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
