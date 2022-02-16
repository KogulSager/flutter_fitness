import 'dart:io';

import 'package:fitness_flutter/models/user.dart';
import 'package:fitness_flutter/services/firestore_service.dart';
import 'package:fitness_flutter/services/storage_service.dart';
import 'package:fitness_flutter/ui/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ComparisonHome extends StatefulWidget {
  //initialize the passed arguments from the previous page
  final UserData user;
  const ComparisonHome({Key? key, required this.user}) : super(key: key);

  @override
  _ComparisonHomeState createState() => _ComparisonHomeState();
}

class _ComparisonHomeState extends State<ComparisonHome> {
  bool beforeSelected = false;
  bool afterSelected = false;
  File? beforeImage;
  File? afterImage;
  String beforeImgUrl = "";
  String afterImgUrl = "";
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Before",
                    style: TextStyle(
                        fontSize: width * 0.08, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 5),
                      color: Colors.black54,
                    ),
                    width: width * 0.45,
                    height: height * 0.4,
                    child: widget.user.beforeImgUrl == ""
                        ? Image.asset("asset/image/before.png")
                        : Image.network(widget.user.beforeImgUrl),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        beforeImage = await _pickImage();
                        setState(() {
                          beforeSelected = true;
                        });
                      },
                      child: beforeSelected
                          ? const Text("Change Image")
                          : const Text("Select Image")),
                  beforeSelected
                      ? ElevatedButton(
                          onPressed: () async {
                            //update the image and get the download url
                            beforeImgUrl = await StorageService()
                                .uploadImage(beforeImage!);

                            //update the url to user's data section
                            FireService().updateBeforeImage(
                                widget.user.uid, beforeImgUrl);
                            Navigator.pop(context); // pop current page
                            Navigator.pushNamed(context, homePageRoute,
                                arguments: [widget.user.uid, 2]);
                          },
                          child: const Text("Upload"))
                      : Container()
                ],
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Column(
                children: [
                  Text(
                    "After",
                    style: TextStyle(
                        fontSize: width * 0.08, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 5),
                      color: Colors.black54,
                    ),
                    width: width * 0.45,
                    height: height * 0.4,
                    child: widget.user.afterImgUrl == ""
                        ? Image.asset("asset/image/after.png")
                        : Image.network(widget.user.afterImgUrl),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueAccent),
                      ),
                      onPressed: () async {
                        afterImage = await _pickImage();
                        setState(() {
                          afterSelected = true;
                        });
                      },
                      child: afterSelected
                          ? const Text("Change Image")
                          : const Text("Select Image")),
                  afterSelected
                      ? ElevatedButton(
                          onPressed: () async {
                            //update the image and get the download url
                            afterImgUrl =
                                await StorageService().uploadImage(afterImage!);

                            //update the url to the user's data section
                            FireService()
                                .updateAfterImage(widget.user.uid, afterImgUrl);

                            Navigator.pop(context); // pop current page
                            Navigator.pushNamed(context, homePageRoute,
                                arguments: [widget.user.uid, 2]);
                          },
                          child: const Text("Upload"))
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Success usually comes to those who are too busy to be looking for it.",
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: width * 0.04, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ));
  }
}

// This function is responsible for pick the image from gallery
Future<File> _pickImage() async {
  final picker = ImagePicker();
  XFile? pickedImage;
  pickedImage =
      await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);
  return File(pickedImage!.path);
}
