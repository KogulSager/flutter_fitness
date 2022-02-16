import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_flutter/services/firestore_service.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:fitness_flutter/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';


// Each and every authentication process is handled by Auth Service Class
class AuthService {

  //Initialize the firebase firestore
  FireService fireService = FireService();

  //Function for registering new user to the app
  Future<void> registerUser(
      context, userName, height, weight, gender, email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
      fireService
          .addUserData(userName, height, weight, gender, email, password,
              userCredential.user!.uid)
          .then((value) async {
        Navigator.pushNamed(context, homePageRoute,
            arguments: [userCredential.user!.uid, 0]);
      });
      showSnackbar(context, "You have successfully registered.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackbar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackbar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  //Function for the log in existing user
  Future<void> loginUser(context, email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        Navigator.pushNamed(context, homePageRoute,
            arguments: [value.user!.uid, 0]);
      });
      showSnackbar(context, "You have successfully logged in.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackbar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackbar(context, 'Wrong password provided for that user.');
      } else {
        showSnackbar(context, e.toString());
      }
    }
  }

  //Function for the logging out current user
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
