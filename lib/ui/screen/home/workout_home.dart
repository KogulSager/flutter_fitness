import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:flutter/material.dart';

class WorkOutHomeScreen extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final UserData user;
  const WorkOutHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _WorkOutHomeScreenState createState() => _WorkOutHomeScreenState();
}

class _WorkOutHomeScreenState extends State<WorkOutHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        //use the created widget with customized data
        workoutCard(context, "ABS", widget, "abs.jpg"),
        workoutCard(context, "ARM", widget, "img01.jpg"),
        workoutCard(context, "CHEST", widget, "chest.jpg"),
        workoutCard(context, "LEG", widget, "leg.jpg"),
        workoutCard(context, "SHOULDER", widget, "shoulder.jpg"),
      ],
    ));
  }
}

//create a widget for workout categories
Widget workoutCard(context, stype, widget, img) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return Column(
    children: [
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, workoutDetailsPageRoute,
              arguments: ['Workout', stype, widget.user]);
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
                  backgroundColor: Colors.black45),
            )),
          ),
        ),
      ),
    ],
  );
}
