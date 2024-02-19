import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/meal.dart';

class MealStorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/meals.json');
  }

  Future<File> writeMeals(List<Meal> meals) async {
    final file = await _localFile;
    // Convert the list of meals to a JSON string
    String mealsJson = json.encode(meals.map((meal) => meal.toJson()).toList());
    // Write the JSON string to the file and return the file
    return file.writeAsString(mealsJson);
  }

  Future<List<Meal>> readMeals() async {
    try {
      final file = await _localFile;
      // Read the file
      String mealsJson = await file.readAsString();
      // Decode the JSON string to a list of meal maps and convert to Meal objects
      List<dynamic> mealListJson = json.decode(mealsJson);
      List<Meal> meals = mealListJson.map((mealJson) => Meal.fromJson(mealJson)).toList();
      return meals;
    } catch (e) {
      // If encountering an error, return an empty list
      return [];
    }
  }

  Future<List<Meal>> getMealsForDate(DateTime date) async {
    List<Meal> allMeals = await readMeals();
    return allMeals.where((meal) {
      // Check if the meal's date matches the specified date, ignoring the time part
      return meal.dateTime.year == date.year &&
             meal.dateTime.month == date.month &&
             meal.dateTime.day == date.day;
    }).toList();
  }
}
