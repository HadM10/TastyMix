import 'package:flutter/material.dart';
import 'recipes.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({Key? key}) : super(key: key);

  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  List<String> selectedIngredients = [];
  List<String> availableIngredients = [
    "Chicken",
    "Pasta",
    "Tomatoes",
    "Cheese",
    "Eggs",
    "Flour",
    "Cocoa",

    // Add more ingredients as needed
  ];

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
            // Show a snack bar message if no ingredients are selected
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select at least one ingredient.'),
              ),
            );
          } else {
            // Navigate to the RecipeDisplayScreen with selected ingredients
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecipeDisplayScreen(selectedIngredients: selectedIngredients),
              ),
            );
          }
        },
        child: const Text('Generate Recipe'),
      ),


    );
  }
}
