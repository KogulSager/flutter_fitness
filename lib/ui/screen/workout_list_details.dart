import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/data/workout_data.dart';
import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/models/workout.dart';
import 'package:fitness_flutter/services/firestore_service.dart';
import 'package:fitness_flutter/services/storage_service.dart';
import 'package:fitness_flutter/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WorkoutListDetails extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final String selectedCategory;
  final String selectedType;
  final UserData user;
  const WorkoutListDetails(
      {Key? key,
      required this.selectedCategory,
      required this.selectedType,
      required this.user})
      : super(key: key);

  @override
  State<WorkoutListDetails> createState() => _WorkoutListDetailsState();
}

class _WorkoutListDetailsState extends State<WorkoutListDetails> {
  FireService fireService = FireService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.selectedType)),

      //Wrapped the iterative workout list tiles with StreamBuilder to get realtime data
      body: StreamBuilder<QuerySnapshot>(
          stream: FireService().workoutsStream(
              widget.user, widget.selectedCategory, widget.selectedType),
          builder: (context, snapshot) {
            //Check the presence of data before pass to the list tiles
            if (snapshot.hasData) {
              //If there is no workout plans, this allows to add predefined workout paln
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Container(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Select your intensity level",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[400]),
                            onPressed: () async {
                              workoutGenerator(
                                  WorkoutData().begginer, widget, context);
                            },
                            child: const Text('Beginner',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[400]),
                            onPressed: () async {
                              workoutGenerator(
                                  WorkoutData().intermediate, widget, context);
                            },
                            child: const Text('Intermediate',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue[400]),
                            onPressed: () async {
                              workoutGenerator(
                                  WorkoutData().advanced, widget, context);
                            },
                            child: const Text('Advanced',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  //Convert the realtime document snapshots to a data object to ease of use
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: data["imageUrl"] == ""
                              ? const Icon(Icons.image, size: 50)
                              : Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                          image: NetworkImage(data["imageUrl"]),
                                          fit: BoxFit.cover)),
                                ),
                          title: Text(data['name']),
                          subtitle: Column(
                            children: [
                              Text(data['des']),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    data['reps'] + " Reps",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _updateWorkoutDialog(
                                            context,
                                            widget.selectedType,
                                            widget,
                                            document);
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        fireService
                                            .removeWorkout(
                                                widget.user.uid,
                                                widget.selectedCategory,
                                                widget.selectedType,
                                                document.id)
                                            .then((value) => {
                                                  showSnackbar(context,
                                                      "You have successfully remove the workout.")
                                                });
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              // Return progress indicator when it is loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () async {
          _addNewWorkoutDialog(context, widget.selectedType, widget);
        },
      ),
    );
  }
}

//Create separate pop up dialog box for get add new entries
Future<void> _addNewWorkoutDialog(context, String type, widget) async {
  String imageUrl = "";
  File? imageFile;
  FireService fireService = FireService();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController desTextController = TextEditingController();
  TextEditingController repsTextController = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ADD NEW ${type} Workout'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: nameTextController,
                decoration: InputDecoration(
                  hintText: "Enter your excercise name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Name",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: desTextController,
                decoration: InputDecoration(
                  hintText: "Enter the Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Description",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: repsTextController,
                decoration: InputDecoration(
                  hintText: "Enter the number of reps",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "No. of Reps",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              ElevatedButton(
                  onPressed: () async {
                    imageFile = await _pickImage();
                  },
                  child: Text("Select Image"))
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Create'),
            onPressed: () async {
              if (imageFile != null) {
                //Upload the image and get download url
                imageUrl = await StorageService().uploadImage(imageFile!);
              }
              //add a new workout entry
              fireService
                  .addWorkout(
                      widget.user.uid,
                      widget.selectedCategory,
                      widget.selectedType,
                      nameTextController.text,
                      desTextController.text,
                      repsTextController.text,
                      imageUrl)
                  .then((value) => {
                        showSnackbar(
                            context, "You have successfully added new workout.")
                      })
                  .then((value) => {
                        Navigator.of(context).pop(),
                      });
            },
          ),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//Create separate pop up dialog box for get add update entries
Future<void> _updateWorkoutDialog(
    context, String type, widget, document) async {
  String imageUrl = "";
  File? imageFile;
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  FireService fireService = FireService();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController desTextController = TextEditingController();
  TextEditingController repsTextController = TextEditingController();
  nameTextController.text = data['name'];
  desTextController.text = data['des'];
  repsTextController.text = data['reps'];

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('UPDATE ${type}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: nameTextController,
                decoration: InputDecoration(
                  hintText: "Enter the exercise name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Name",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: desTextController,
                decoration: InputDecoration(
                  hintText: "Enter the Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "Description",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: repsTextController,
                decoration: InputDecoration(
                  hintText: "Enter the no of reps",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "No. of Reps",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              ElevatedButton(
                  onPressed: () async {
                    imageFile = await _pickImage();
                  },
                  child: Text("Update Image"))
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Update'),
            onPressed: () async {
              if (imageFile != null) {
                imageUrl = await StorageService().uploadImage(imageFile!);
              } else {
                imageUrl = data["imageUrl"];
              }
              //Update a current workout entry with new values
              fireService
                  .updateWorkout(
                      widget.user.uid,
                      widget.selectedCategory,
                      widget.selectedType,
                      nameTextController.text,
                      desTextController.text,
                      repsTextController.text,
                      imageUrl,
                      document.id)
                  .then((value) => {
                        showSnackbar(context,
                            "You have successfully updated the workout.")
                      })
                  .then((value) => {
                        Navigator.of(context).pop(),
                      });
            },
          ),
          ElevatedButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// This function is responsible for pick the image from gallery
Future<File> _pickImage() async {
  final picker = ImagePicker();
  XFile? pickedImage;
  pickedImage =
      await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
  return File(pickedImage!.path);
}

//This is add data to the firestore getting from the pre-defined data templates
void workoutGenerator(List<Workout> workoutList, widget, context) {
  FireService fireService = FireService();
  for (Workout workout in workoutList) {
    fireService.addWorkout(
        widget.user.uid,
        widget.selectedCategory,
        widget.selectedType,
        workout.name,
        workout.des,
        workout.reps,
        workout.imageUrl);
  }
  showSnackbar(context, "You have successfully added the workouts.");
}
