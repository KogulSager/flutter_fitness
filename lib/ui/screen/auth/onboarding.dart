import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'loginpage.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentPage = 0;
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PageView(
                  controller: _pageController,
                  children: [
                    onBoardPage("onboard1", "Workout anywhere",
                        "You can do your workout at home without any equipment, outside or at the gym."),
                    onBoardPage("onboard2", "Learn techniques",
                        "Our workout programs are made by professionals."),
                    onBoardPage("onboard3", "Stay strong & healthy",
                        "We want you to fully enjoy the program and stay healthy and positive."),
                  ],
                  onPageChanged: (value) => {setCurrentPage(value)},
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => getIndicator(index)),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.blue[400]),
                      onPressed: () async {
                        Navigator.pushNamed(context, registerPageRoute);
                      },
                      child: const Text('Create Account',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.blue[400]),
                      onPressed: () async {
                        Navigator.pushNamed(context, loginPageRoute);
                      },
                      child: const Text('Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  AnimatedContainer getIndicator(int pageNo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: 10,
      width: (currentPage == pageNo) ? 20 : 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: (currentPage == pageNo) ? Colors.black : Colors.grey),
    );
  }

  Column onBoardPage(String img, String title, String detail) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage('asset/image/$img.png'))),
        ),
        const SizedBox(
          height: 50,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Text(
            detail,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  setCurrentPage(int value) {
    currentPage = value;
    setState(() {});
  }

  openLoginPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
