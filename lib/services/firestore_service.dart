import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/models/diet.dart';
import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/models/workout.dart';


//Firestore database related CRUD operations are handled bu the FireService class
class FireService {

  //Creating a reference for users collection to the UserDara Model
  final userDataRef =
      FirebaseFirestore.instance.collection('users').withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromMap(snapshot.data()!),
            toFirestore: (user, _) => user.toMap(),
          );

  //Adding data to the firestore at the registration is handled by this function
  Future<void> addUserData(
      userName, height, weight, gender, email, password, uid) async {
    print("hi");
    userDataRef.doc(uid).set(UserData(
        userName: userName,
        email: email,
        password: password,
        uid: uid,
        review: 0,
        beforeImgUrl: '',
        afterImgUrl: '',
        height: height,
        gender: gender,
        reviewText: '',
        weight: weight));
  }

  //This function is responsible for get the current users data
  Future<UserData> getUserData(uid) async {
    UserData userData =
        await userDataRef.doc(uid).get().then((snapshot) => snapshot.data()!);
    return userData;
  }

  //this function is responsible for add or update review
  Future<void> updateReview(uid, review, reviewText) async {
    userDataRef.doc(uid).update({"review": review, "reviewText": reviewText});
  }



  Future<void> updateBeforeImage(uid, beforeImgUrl) async {
    userDataRef.doc(uid).update({"beforeImgUrl": beforeImgUrl});
  }




  //CRUD operations related to Workout data model are handled by following functions
  Future<void> addWorkout(uid, category, type, name, des, reps, imgUrl) async {
    userDataRef
        .doc(uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .doc()
        .set(Workout(name: name, reps: reps, imageUrl: imgUrl, des: des)
        .toMap());
  }

  Future<void> updateAfterImage(uid, afterImgUrl) async {
    userDataRef.doc(uid).update({"afterImgUrl": afterImgUrl});
  }

  Future<void> updateWorkout(
      uid, category, type, name, des, reps, imgUrl, doc) async {
    userDataRef
        .doc(uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .doc(doc)
        .update(Workout(name: name, reps: reps, imageUrl: imgUrl, des: des)
            .toMap());
  }

  Future<void> removeWorkout(uid, category, type, doc) async {
    userDataRef
        .doc(uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .doc(doc)
        .delete();
  }

  //CRUD operations related to Diet data model are handled by following functions
  Future<void> addDiet(
      uid, category, type, food, des, calories, imageUrl) async {
    userDataRef
        .doc(uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .doc()
        .set(Diet(food: food, calories: calories, imageUrl: imageUrl, des: des)
            .toMap());
  }

  Future<void> updateDiet(
      uid, category, type, food, des, calories, imageUrl, doc) async {
    userDataRef
        .doc(uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .doc(doc)
        .update(
            Diet(food: food, calories: calories, imageUrl: imageUrl, des: des)
                .toMap());
  }

  Future<void> removeDiet(uid, category, type, doc) async {
    userDataRef
        .doc(uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .doc(doc)
        .delete();
  }


  // Realtime data is handled by the following stream functions
  Stream<QuerySnapshot> workoutsStream(UserData user, category, type) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .snapshots();
  }

  Stream<QuerySnapshot> dietsStream(UserData user, category, type) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection(category)
        .doc(category)
        .collection(type)
        .snapshots();
  }

  Stream<QuerySnapshot> reviewsStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
}
