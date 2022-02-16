import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/services/auth_service.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:fitness_flutter/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:provider/src/provider.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class OpenNewRegistration extends StatelessWidget {
  const OpenNewRegistration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const NewRegistration();
  }
}

class NewRegistration extends StatefulWidget {
  const NewRegistration({Key? key}) : super(key: key);

  @override
  _NewRegistrationState createState() => _NewRegistrationState();
}

class _NewRegistrationState extends State<NewRegistration> {
  String genderType = "Gender.Male";
  AuthService authService = AuthService();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController heightTextController = TextEditingController();
  TextEditingController weightTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: height * 0.88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 35),
                    ),
                    TextField(
                      controller: userNameTextController,
                      decoration: InputDecoration(
                          labelText: "User Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter the User Name here"),
                      style: const TextStyle(fontSize: 15),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: heightTextController,
                      decoration: InputDecoration(
                          labelText: "Height",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter the height in cm"),
                      style: const TextStyle(fontSize: 15),
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: weightTextController,
                      decoration: InputDecoration(
                          labelText: "Weight",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter the weight in kg"),
                      style: const TextStyle(fontSize: 15),
                    ),
                    GenderPickerWithImage(
                      verticalAlignedText: false,
                      selectedGender: Gender.Male,
                      selectedGenderTextStyle: TextStyle(
                          color: Color(0xFF8b32a8),
                          fontWeight: FontWeight.bold),
                      unSelectedGenderTextStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                      onChanged: (Gender? gender) {
                        genderType = gender.toString();
                      },
                      equallyAligned: true,
                      animationDuration: Duration(milliseconds: 300),
                      isCircular: true,
                      // default : true,
                      opacityOfGradient: 0.4,
                      padding: const EdgeInsets.all(3),
                      size: 50, //default : 40
                    ),
                    TextField(
                      controller: emailTextController,
                      decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Enter your Email here"),
                      style: const TextStyle(fontSize: 15),
                    ),
                    TextField(
                      controller: passwordTextController,
                      decoration: InputDecoration(
                        hintText: "Enter your Password here",
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: true,
                      style: const TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.blue[400]),
                        onPressed: () async {
                          //call the function for register new user with obtained new data
                          authService.registerUser(
                              context,
                              userNameTextController.text,
                              int.parse(heightTextController.text),
                              int.parse(weightTextController.text),
                              genderType,
                              emailTextController.text,
                              passwordTextController.text);
                        },
                        child: const Text('Signup',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, loginPageRoute);
                          },
                          child: const Text('Login',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                              )),
                        ),
                      ],
                    ),
                    const Text(
                      "All Rights Reserved.",
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            ))),
      ),
    );
  }
}
