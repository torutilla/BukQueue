import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageImageHandler {
  final String imageUrl;
  FirebaseStorageImageHandler({required this.imageUrl});
  final fireStorage = FirebaseStorage.instance;

  void retrieveFirebasePhoto() {
    final storageRef = fireStorage.ref();
    Reference? profilePhotoRef = storageRef.child('profile_photos');
    profilePhotoRef.child('driver/$imageUrl');
  }

  Future<void> addPhoto() async {
    var appDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDir.absolute}';
  }
}
