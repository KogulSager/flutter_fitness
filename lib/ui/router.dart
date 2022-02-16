import 'package:fitness_flutter/main.dart';
import 'package:fitness_flutter/ui/screen/auth/loginpage.dart';
import 'package:fitness_flutter/ui/screen/auth/newregistration.dart';
import 'package:fitness_flutter/ui/screen/auth/onboarding.dart';
import 'package:fitness_flutter/ui/screen/diet_list_details.dart';
import 'package:fitness_flutter/ui/screen/home/homepage.dart';
import 'package:fitness_flutter/ui/screen/workout_list_details.dart';
import 'package:flutter/material.dart';
import 'constants/route_constants.dart';

//Named routes and their arguments are created here
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashPageRoute:
      return MaterialPageRoute(builder: (context) => const SplashPage());
    case onBoardingPageRoute:
      return MaterialPageRoute(builder: (context) => const OnBoarding());
    case loginPageRoute:
      return MaterialPageRoute(builder: (context) => const LoginPage());
    case registerPageRoute:
      return MaterialPageRoute(builder: (context) => const NewRegistration());
    case homePageRoute:
      var arguments = settings.arguments as List;
      return MaterialPageRoute(
          builder: (context) =>
              HomePage(uid: arguments[0], initIndex: arguments[1]));
    case dietDetailsPageRoute:
      var arguments = settings.arguments as List;
      return MaterialPageRoute(
          builder: (context) => DietListDetails(
                selectedCategory: arguments[0],
                selectedType: arguments[1],
                user: arguments[2],
              ));
    case workoutDetailsPageRoute:
      var arguments = settings.arguments as List;
      return MaterialPageRoute(
          builder: (context) => WorkoutListDetails(
                selectedCategory: arguments[0],
                selectedType: arguments[1],
                user: arguments[2],
              ));
    default:
      return MaterialPageRoute(builder: (context) => const LoginPage());
  }
}
