import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Future<XFile?> selectImage() async {
    final ImagePicker imagePicker = ImagePicker();
    return await imagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadImageToFirebase(
      XFile file,
      String storagePath,
      void Function(UploadTask uploadTask, String downloadUrl)? callBack,
      void Function()? onError) async {
    try {
      File uploadFile = File(file.path);
      final rootRef = firebaseStorage.ref();
      final storageRef = rootRef.child(storagePath);
      UploadTask uploadTask = storageRef.putFile(uploadFile);
      String url = await storageRef.getDownloadURL();
      if (callBack != null) {
        callBack(uploadTask, url);
      }
    } catch (e) {
      if (onError != null) {
        onError();
      }
    }
  }

  Future<String> retrieveImageByPath(String path) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref(path);

      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error getting download URL: $e");
      return "";
    }
  }
}
