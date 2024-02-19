
class FoodItem {
  String name;
  int calories; // Calories per serving
  int protein; // Protein per serving
  int quantity; // Number of servings

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.quantity,
  });

  // Total calories based on quantity
  int get totalCalories => calories * quantity;

  // Total protein based on quantity
  int get totalProtein => protein * quantity;

  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'quantity': quantity,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
      calories: json['calories'],
      protein: json['protein'],
      quantity: json['quantity'],
    );
  }
}


class Meal {
  DateTime dateTime;
  List<FoodItem> items;

  Meal({required this.dateTime, required this.items});

  // Calculate total calories for the meal
  int get totalCalories => items.fold(0, (sum, item) => sum + item.totalCalories);

  // Calculate total protein for the meal
  int get totalProtein => items.fold(0, (sum, item) => sum + item.totalProtein);

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
        // Include calculated totals directly in the JSON
        'totalCalories': totalCalories,
        'totalProtein': totalProtein,
      };

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      dateTime: DateTime.parse(json['dateTime']),
      items: List<FoodItem>.from(json['items'].map((item) => FoodItem.fromJson(item))),
      // The totals will be recalculated based on items, so they don't need to be directly parsed from JSON
    );
  }
}