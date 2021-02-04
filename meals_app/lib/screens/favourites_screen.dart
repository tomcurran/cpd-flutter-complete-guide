import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_item.dart';

class FavouritesScreen extends StatelessWidget {
  static const String routeName = '/favourites';

  final List<Meal> favouriteMeals;

  const FavouritesScreen({
    Key key,
    this.favouriteMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (favouriteMeals.isEmpty) {
      return Center(
        child: Text('You have no favourites yet - start ading some!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, index) {
          var mealAtIndex = favouriteMeals[index];
          return MealItem(
            id: mealAtIndex.id,
            title: mealAtIndex.title,
            imageUrl: mealAtIndex.imageUrl,
            duration: mealAtIndex.duration,
            complexity: mealAtIndex.complexity,
            affordability: mealAtIndex.affordability,
          );
        },
        itemCount: favouriteMeals.length,
      );
    }
  }
}
