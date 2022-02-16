//Data model for the workout entries
class Workout {
  final String name;
  final String des;
  final String reps;
  final String imageUrl;

  Workout(
      {required this.name,
      required this.des,
      required this.reps,
      required this.imageUrl});

  Map<String, dynamic> toMap() =>
      {"name": name, "des": des, "reps": reps, "imageUrl": imageUrl};

  Workout.fromMap(Map<String, dynamic> data)
      : name = data["name"],
        des = data["des"],
        reps = data["reps"],
        imageUrl = data["imageUrl"];
}
