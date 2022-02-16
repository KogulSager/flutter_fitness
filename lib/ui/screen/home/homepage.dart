import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/services/auth_service.dart';
import 'package:fitness_flutter/services/firestore_service.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:fitness_flutter/ui/screen/home/comparison_home.dart';
import 'diet_home.dart';
import 'workout_home.dart';
import 'package:flutter/material.dart';
import 'user_review.dart';

class HomePage extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final String uid;
  final int initIndex;
  HomePage({Key? key, required this.uid, required this.initIndex})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //final colorstheme = Color(0xff2ac3ff); //Color(0xff4b4b87);

  late TabController _tabController;
  @override
  void initState() {
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.initIndex)
          ..addListener(() {});
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: const Text(
          'Health and Fitness',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            AuthService().signOut();
            Navigator.pushNamed(context, loginPageRoute);
          }, icon: const Icon(Icons.logout))
        ],
        //Create the tabs related to home page
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle:
              const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          indicatorPadding: const EdgeInsets.all(5),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const <Widget>[
            Tab(
              text: 'Workout',
            ),
            Tab(
              text: 'Diet Food',
            ),
            Tab(
              text: 'Comparison',
            ),
            Tab(
              text: 'User Review',
            ),
          ],
        ),
      ),

      //inisialize those tabs to the body of the home page
      body: FutureBuilder<UserData>(
          future: FireService().getUserData(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                controller: _tabController,
                children: [
                  WorkOutHomeScreen(
                    user: snapshot.data!,
                  ),
                  DietHomeScreen(
                    user: snapshot.data!,
                  ),
                  ComparisonHome(
                    user: snapshot.data!,
                  ),
                  UserReview(
                    user: snapshot.data!,
                  ),
                ],
              );
            } else if (snapshot.error != null) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
