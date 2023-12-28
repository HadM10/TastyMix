import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipes.dart'; // Import your RecipeDisplayScreen or adjust the import as needed

class Ingredients extends StatefulWidget {
  const Ingredients({Key? key}) : super(key: key);

  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  List<String> selectedIngredients = [];
  List<String> availableIngredients = []; // Updated to fetch ingredients from the backend

  @override
  void initState() {
    super.initState();
    fetchAvailableIngredients(); // Fetch ingredients when the widget initializes
  }

  Future<void> fetchAvailableIngredients() async {
    try {
      final response = await http.get(Uri.parse('https://tastymix.000webhostapp.com/get_available_ingredients.php'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          availableIngredients = jsonResponse.cast<String>();
        });
      } else {
        throw Exception('Failed to load ingredients');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Ingredients'),
      ),
      body: ListView.builder(
        itemCount: availableIngredients.length,
        itemBuilder: (context, index) {
          final ingredient = availableIngredients[index];
          return ListTile(
            title: Text(ingredient),
            trailing: Checkbox(
              value: selectedIngredients.contains(ingredient),
              onChanged: (value) {
                setState(() {
                  if (value != null && value) {
                    selectedIngredients.add(ingredient);
                  } else {
                    selectedIngredients.remove(ingredient);
                  }
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: selectedIngredients.isEmpty
            ? null // Disable the button if no ingredients are selected
            : () {
          if (selectedIngredients.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select at least one ingredient.'),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDisplayScreen(selectedIngredients: selectedIngredients),
              ),
            );
          }
        },
        child: const Text('Generate Recipe'),
      ),
    );
  }
}
