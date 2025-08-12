import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/cachedDocumentId.dart';
// import 'package:flutter_try_thesis/models/dateTimeConverter.dart';
import 'package:flutter_try_thesis/models/firestore_operations/firestoreOperations.dart';
import 'package:flutter_try_thesis/models/providers/argon2.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';
import 'package:flutter_try_thesis/models/uploadImage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String userID = '';
  XFile? profilePicture;
  List<XFile> licensePhotos = [];
  String restrictionCodes = '';
  Map<String, dynamic> userInfo = {}; //store in cache
  Map<String, dynamic> vehicleInfo = {}; //store in cache
  FirestoreOperations firestoreOperations = FirestoreOperations();
  UserSharedPreferences sharedPreferences = UserSharedPreferences();
  PasswordHashArgon2 argon2Hash = PasswordHashArgon2();
  CachedDocument cachingDoc = CachedDocument();
  String password = '';
  DateTime? expiryDate;
  String licenseNumber = '';
  String licenseType = '';
  ImageUpload imageUpload = ImageUpload();
  Future<void> addUserToDatabase(String uid, {bool isDriver = false}) async {
    final salt = argon2Hash.generateRandomSalt();
    var finalPassword = argon2Hash.generateHashedPassword(password, salt);
    userInfo['Salt'] = salt;
    userInfo['Hash'] = finalPassword;
    userInfo['UID'] = uid;
    userInfo['Role'] = isDriver ? 'Driver' : 'Commuter';
    if (isDriver) {
      userInfo['Verification Status'] = 'Pending';
    }
    await UserSharedPreferences().addToCache({'UID': uid});
    try {
      if (userInfo.isNotEmpty) {
        if (vehicleInfo.isNotEmpty && isDriver) {
          userInfo.addAll(vehicleInfo);
          final links = await uploadLicenseAndProfile(uid);
          userInfo.addAll(links);
        }
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .set(userInfo);
        await cachingDoc.storeId(uid);
        // final userExists = await checkIfUserAlreadyExists(userInfo['UID']);
        // if (userExists.isNotEmpty) {
        //   firestoreOperations.updateDatabaseValues('Users', userExists[0].id, {
        //     'Role': FieldValue.arrayUnion([userInfo['Role']])
        //   });
        // } else {
        // await firestoreOperations.addDataToDatabase(
        //   'Users',
        //   userInfo,
        //   onCompleteAdd: (id) {
        //     userID = id;
        //   },
        // );
        // if (isDriver) {
        //   firestoreOperations.addDataToDatabase(
        //       'Users',
        //       documentPath: userID,
        //       subCollectionPath: 'Vehicle Info',
        //       vehicleInfo);
        // }
        // }
      }
    } catch (e) {
      print('Error adding user: $e');
    }
    notifyListeners();
  }

  void addLicensePhotos(XFile value) {
    licensePhotos.add(value);
    notifyListeners();
  }

  void addProfilePhoto(XFile value) {
    profilePicture = value;
    notifyListeners();
  }

  Future<void> updateUserInfo(
    String fullName,
    String contactNumber,
  ) async {
    userInfo = {
      "Full Name": fullName,
      "Contact Number": contactNumber,
    };
    await sharedPreferences.addToCache(userInfo);

    notifyListeners();
  }

  void addLicenseInfo(
    String number,
    List<String> codes,
    String type,
    String expDate,
  ) {
    licenseNumber = number;
    restrictionCodes = codes.join(", ");
    licenseType = type;
    final convertToDate = DateTime.tryParse(expDate);
    expiryDate = convertToDate;
    // print(expiryDate);
    notifyListeners();
  }

  void storeLicenseInfoToCache(
      String number, String restrictions, String type, Timestamp expiry) {
    licenseNumber = number;
    restrictionCodes = restrictions;
    licenseType = type;
    expiryDate = expiry.toDate();
  }

  void updateVehicleInfo(
    String operatorName,
    String orcrNumber,
    String orcrDate,
    String bodyNumber,
    String mtopNumber,
    String plateNumber,
    String vehicleType,
    String chassisNumber,
    String zone,
  ) {
    final expiryDateInTimestamp = Timestamp.fromDate(expiryDate!);
    vehicleInfo = {
      "Vehicle Type": vehicleType,
      "Operator Name": operatorName,
      "OR_CR Number": orcrNumber,
      "OR Expiry Date": orcrDate,
      "Zone Number": zone,
      "Body Number": bodyNumber,
      "Plate Number": plateNumber,
      "Chassis Number": chassisNumber,
      "MTOP Number": mtopNumber,
      "License Type": licenseType,
      "License Number": licenseNumber,
      "License Expiry": expiryDateInTimestamp,
      "Restrictions": restrictionCodes,
    };
    // if (userID.isNotEmpty) {
    //   firestoreOperations.addDataToDatabase(
    //       'Users',
    //       documentPath: userID,
    //       subCollectionPath: 'Vehicle Info',
    //       vehicleInfo);
    // }
    // vehicleInfo['License Expiry'] = expiryDate.toString();

    notifyListeners();
  }

  Future<void> addVehicleInfoToCache() async {
    await sharedPreferences.addToCache(vehicleInfo);
  }

  Future<Map<String, String>> uploadLicenseAndProfile(String uid,
      {void Function()? onErrorUpload,
      void Function()? afterSuccessfulUpload}) async {
    Map<String, String> links = {};
    // final collectionRef = FirebaseFirestore.instance.collection('Users');

    String pfpStoragePath = 'userUploads/$uid';
    await imageUpload.uploadImageToFirebase(
        XFile(profilePicture!.path), pfpStoragePath, (upload, url) {
      links['Photo Link'] = url;
    }, onErrorUpload);
    for (int i = 0; i < licensePhotos.length; i++) {
      String storagePath = 'driverUploads/userDriverLicense_${uid}_${i + 1}';
      await imageUpload.uploadImageToFirebase(
        licensePhotos[i],
        storagePath,
        (uploadTask, url) async {
          links["License Link ${i + 1}"] = url;
          // try {
          //   await collectionRef.doc(userID).update({
          //     "License Link ${i + 1}": url,
          //   });
          // } catch (e) {
          //   print("Failed to update document with id $userID: $e");
          // }
        },
        onErrorUpload,
      );
    }
    // try {
    //   await collectionRef.doc(userID).update({"Photo Link": pfpLink});
    // } catch (e) {
    //   print("Failed to update document with id $userID: $e");
    // }

    if (afterSuccessfulUpload != null) {
      afterSuccessfulUpload();
    }
    return links;
  }

  // Future<List<QueryDocumentSnapshot>> checkIfUserAlreadyExists(
  //     String uid) async {
  //   final userSnapshots = await firestoreOperations
  //       .retrieveCollectionSnapshots('Users', where: 'UID', equalTo: uid);
  //   return userSnapshots.docs;
  // }
}
