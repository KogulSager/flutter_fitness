import 'package:fitness_flutter/services/auth_service.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: height * 0.88,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.15,
                      child: Image.asset("asset/image/logo.png"),
                    ),
                    const Text(
                      "Welcome",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35),
                    ),
                    const Text(
                      "to the Health and Fitness",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: emailTextController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter your email here",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: passwordTextController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: "Password",
                              hintText: "Enter your password here"),
                          obscureText: true,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.blue[400]),
                        onPressed: () async {
                          //handled the functions for login existing user
                          authService
                              .loginUser(context, emailTextController.text,
                                  passwordTextController.text)
                              .then((value) => {});
                        },
                        child: const Text('Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't you have account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            openNewRegistration(context);
                          },
                          child: const Text('Register',
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
            ),
          ),
        ),
      ),
    );
  }

  void openNewRegistration(context) {
    Navigator.pushNamed(context, registerPageRoute);
  }


  //create customized snackbar for show the login errors
  void showSnackBar() {
    final snackbar = SnackBar(
      content: Row(children: const [
        Icon(Icons.error_outline_sharp, size: 32, color: Colors.white),
        SizedBox(width: 20),
        Expanded(
            child: Text('Login details are invalid..',
                style: TextStyle(fontSize: 20)))
      ]),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.indigo.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      behavior: SnackBarBehavior.floating,
      //width: 350,
      shape: const StadiumBorder(),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
