import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';

class AccountBanning {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  UserSharedPreferences sharedPrefs = UserSharedPreferences();
  DateTime banDate = DateTime(2001, 01, 01);

  Future<String?> _getID() async {
    String? commuterUID = await sharedPrefs.readCacheString('UID');
    return commuterUID;
  }

  DateTime banningTime() {
    return banDate;
  }

  void banAccount() async {
    try {
      String? uid = await _getID();
      var accountQuery =
          await instance.collection("Users").where('UID', isEqualTo: uid).get();
      if (accountQuery.docs.isEmpty) return;

      String accountID = accountQuery.docs[0].id;

      await instance.collection('Users').doc(accountID).set({
        "Banned Until": banningTime(),
      });
    } catch (e) {
      print("Failed banning user account: $e");
    }
  }

  Future<bool> isAccountBanned() async {
    try {
      String? uid = await _getID();
      if (uid == null) return false;

      var accountQuery =
          await instance.collection("Users").where('UID', isEqualTo: uid).get();

      if (accountQuery.docs.isEmpty) return false;

      var accountID = accountQuery.docs[0].id;
      var doc = await instance.collection('Users').doc(accountID).get();

      var data = doc.data();
      if (data == null || !data.containsKey("Banned Until")) return false;

      final ban = (data["Banned Until"] as Timestamp).toDate();
      banDate = ban;
      return DateTime.now().isBefore(ban);
    } catch (e) {
      print("Error checking ban status: $e");
      return false;
    }
  }
}
