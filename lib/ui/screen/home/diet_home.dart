import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:flutter/material.dart';
import '../diet_list_details.dart';

class DietHomeScreen extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final UserData user;
  const DietHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DietHomeScreenState createState() => _DietHomeScreenState();
}

class _DietHomeScreenState extends State<DietHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        //use the created widgets with customised data
        dietCard(context, "PLANT BASED DIETS", widget, "plant based diets.jpg"),
        dietCard(context, "LOW CARB DIETS", widget, "low carb diets.jpg"),
        dietCard(context, "PALEO DIETS", widget, "paleo diet.jpg"),
        dietCard(context, "LOW FAT DIETS", widget, "low fat diets.jpg"),
        dietCard(context, "DASH DIETS", widget, "dash diet.jpg"),
      ],
    ));
  }
}

//create widget for diet categories
Widget dietCard(context, stype, widget, img) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return Column(
    children: [
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, dietDetailsPageRoute,
              arguments: ['Diet', stype, widget.user]);
        },
        child: Card(
          child: Container(
            height: height * 0.136,
            width: width * 0.92,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage('asset/image/$img'), fit: BoxFit.cover)),
            child: Center(
                child: Text(
              stype,
              style: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.w900,
                  backgroundColor: Colors.black54),
            )),
          ),
        ),
      ),
    ],
  );
}
