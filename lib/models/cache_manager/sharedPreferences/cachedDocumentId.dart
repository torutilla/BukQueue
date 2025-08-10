import 'package:flutter_try_thesis/models/cache_manager/sharedPreferences/userSharedPreferences.dart';

class CachedDocument {
  final sharedPreferences = UserSharedPreferences();
  static String? documentId;
  Future<void> storeId(String id) async {
    try {
      await sharedPreferences.addToCache({"DocumentId": id});
    } catch (e) {
      print("Error storing id: $e");
    }
  }

  Future<String?> getDocumentId() async {
    documentId = await sharedPreferences.readCacheString("DocumentId");
    return documentId;
  }
}
