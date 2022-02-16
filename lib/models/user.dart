// Data model for the user's data
class UserData {
  final String userName;
  final int height;
  final int weight;
  final String gender;
  final String email;
  final String password;
  final String uid;
  final int review;
  final String reviewText;
  final String beforeImgUrl;
  final String afterImgUrl;

  UserData(
      {required this.userName,
      required this.height,
      required this.weight,
      required this.gender,
      required this.email,
      required this.password,
      required this.uid,
      required this.review,
      required this.reviewText,
      required this.beforeImgUrl,
      required this.afterImgUrl});

  Map<String, dynamic> toMap() => {
        "userName": userName,
        "height": height,
        "weight": weight,
        "gender": gender,
        "email": email,
        "password": password,
        "uid": uid,
        "review": review,
        "reviewText": reviewText,
        "beforeImgUrl": beforeImgUrl,
        "afterImgUrl": afterImgUrl
      };

  UserData.fromMap(Map<String, dynamic> data)
      : userName = data["userName"],
        height = data["height"],
        weight = data["weight"],
        gender = data["gender"],
        email = data["email"],
        password = data["password"],
        uid = data["uid"],
        review = data["review"],
        reviewText = data["reviewText"],
        beforeImgUrl = data["beforeImgUrl"],
        afterImgUrl = data["afterImgUrl"];
}
