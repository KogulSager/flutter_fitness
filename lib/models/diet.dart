//Data Model for the Diet Entries
class Diet {
  final String food;
  final String des;
  final String calories;
  final String imageUrl;

  Diet(
      {required this.food,
      required this.des,
      required this.calories,
      required this.imageUrl});

  Map<String, dynamic> toMap() =>
      {"food": food, "des": des, "calories": calories, "imageUrl": imageUrl};

  Diet.fromMap(Map<String, dynamic> data)
      : food = data["food"],
        des = data["des"],
        calories = data["calories"],
        imageUrl = data["imageUrl"];
}
