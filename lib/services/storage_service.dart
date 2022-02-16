import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:min_id/min_id.dart';

//Firebase Storage related tasks are handled by this class
class StorageService {
  //This class is responsible for uploading the images to the firebase storage
  Future<String> uploadImage(File imageFile) async {
    final filename = MinId.getId();
    await firebase_storage.FirebaseStorage.instance
        .ref('uploads/$filename')
        .putFile(imageFile)
        .then((p0) => {});
    return await firebase_storage.FirebaseStorage.instance
        .ref('uploads/$filename')
        .getDownloadURL();
  }
}
