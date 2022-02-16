import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_flutter/data/diet_data.dart';
import 'package:fitness_flutter/models/diet.dart';
import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/services/firestore_service.dart';
import 'package:fitness_flutter/services/storage_service.dart';
import 'package:fitness_flutter/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DietListDetails extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final String selectedCategory;
  final String selectedType;
  final UserData user;
  const DietListDetails(
      {Key? key,
      required this.selectedCategory,
      required this.selectedType,
      required this.user})
      : super(key: key);

  @override
  State<DietListDetails> createState() => _DietListDetailsState();
}

class _DietListDetailsState extends State<DietListDetails> {
  FireService fireService = FireService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedType),
        backgroundColor: Colors.black,
      ),

      //Wrapped the iterative diet list tiles with StreamBuilder to get realtime data
      body: StreamBuilder<QuerySnapshot>(
          stream: FireService().dietsStream(
              widget.user, widget.selectedCategory, widget.selectedType),
          builder: (context, snapshot) {
            //Check the presence of data before pass to the list tiles
            if (snapshot.hasData) {
              //If there is no diet plans, this allows to add predefined diet paln
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Container(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "What do you wand to do?",
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
                              dietGenerator(
                                  DietData().weightGain, widget, context);
                            },
                            child: const Text('Weight Gain',
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
                              dietGenerator(
                                  DietData().weightLoss, widget, context);
                            },
                            child: const Text('Weight Loss',
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
                              dietGenerator(
                                  DietData().weightMaintain, widget, context);
                            },
                            child: const Text('Weight Maintain',
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
                //Convert the realtime document snapshots to a data object to ease of use
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                          image: NetworkImage(data["imageUrl"]),
                                          fit: BoxFit.cover)),
                                ),
                          title: Text(data['food']),
                          subtitle: Column(
                            children: [
                              Text(data['des']),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    data['calories'] + " Calories",
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w900),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _updateDietDialog(
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
                                            .removeDiet(
                                                widget.user.uid,
                                                widget.selectedCategory,
                                                widget.selectedType,
                                                document.id)
                                            .then((value) => {
                                                  showSnackbar(context,
                                                      "You have successfully removed the diet.")
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
          _addNewDietDialog(context, widget.selectedType, widget);
        },
      ),
    );
  }
}

Future<void> _addNewDietDialog(context, String type, widget) async {
  String imageUrl = "";
  File? imageFile;
  FireService fireService = FireService();
  TextEditingController foodTextController = TextEditingController();
  TextEditingController desTextController = TextEditingController();
  TextEditingController caloriesTextController = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ADD NEW ${type}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: foodTextController,
                decoration: InputDecoration(
                  hintText: "Enter the name of food",
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
                  hintText: "Enter the description",
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
                controller: caloriesTextController,
                decoration: InputDecoration(
                  hintText: "Enter the no of calories",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "No. of Calories",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              ElevatedButton(
                  onPressed: () async {
                    imageFile = await _pickImage();
                  },
                  child: const Text("Select Image"))
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
              //Add a new diet entry
              fireService
                  .addDiet(
                      widget.user.uid,
                      widget.selectedCategory,
                      widget.selectedType,
                      foodTextController.text,
                      desTextController.text,
                      caloriesTextController.text,
                      imageUrl)
                  .then((value) => {
                        showSnackbar(
                            context, "You have successfully added new Diet.")
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

Future<void> _updateDietDialog(context, String type, widget, document) async {
  String imageUrl = "";
  File? imageFile;
  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  FireService fireService = FireService();
  TextEditingController foodTextController = TextEditingController();
  TextEditingController desTextController = TextEditingController();
  TextEditingController caloriesTextController = TextEditingController();
  foodTextController.text = data['food'];
  desTextController.text = data['des'];
  caloriesTextController.text = data['calories'];
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
                controller: foodTextController,
                decoration: InputDecoration(
                  hintText: "Enter the name of food",
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
                  hintText: "Enter the description of food",
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
                controller: caloriesTextController,
                decoration: InputDecoration(
                  hintText: "Enter the no of calories",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "No. of Calories",
                ),
                style: const TextStyle(fontSize: 15),
              ),
              ElevatedButton(
                  onPressed: () async {
                    imageFile = await _pickImage();
                  },
                  child: const Text("Select Image"))
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
              //Update a current diet entry with new values
              fireService
                  .updateDiet(
                      widget.user.uid,
                      widget.selectedCategory,
                      widget.selectedType,
                      foodTextController.text,
                      desTextController.text,
                      caloriesTextController.text,
                      imageUrl,
                      document.id)
                  .then((value) => {
                        showSnackbar(
                            context, "You have successfully updated the diet.")
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
void dietGenerator(List<Diet> dietList, widget, context) {
  FireService fireService = FireService();
  for (Diet diet in dietList) {
    fireService.addDiet(widget.user.uid, widget.selectedCategory,
        widget.selectedType, diet.food, diet.des, diet.calories, diet.imageUrl);
  }
  showSnackbar(context, "You have successfully added the diets.");
}
