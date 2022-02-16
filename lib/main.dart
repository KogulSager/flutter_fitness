import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:fitness_flutter/ui/router.dart' as router;
import 'package:flutter/services.dart';

//This is the main entry of the app. As this is directly connected to firebase, firebase app also initialized at entry poin.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //The app orientation is locked for only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    //this is the first widget of the app
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      //Named routes are initialized here
      onGenerateRoute: router.generateRoute,

      //Setup initial route as splash page
      initialRoute: splashPageRoute,
    );
  }
}



class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    //Setup the timer for splash page
    Timer(const Duration(seconds: 3), openLoginPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Image(
            image: AssetImage('asset/image/img01.jpg'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 4,
            left: 140,
            top: 580,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white.withOpacity(0.1),
                child: const Text(
                  'Health and Fitness',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void openLoginPage() {
    Navigator.pushNamed(context, onBoardingPageRoute);
  }
}
