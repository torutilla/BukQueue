import 'package:cloud_firestore/cloud_firestore.dart';

class GetBookingHistoryofUser {
  Future<List<Map<String, dynamic>>> generateUserBookingHistory(String uid,
      {bool isDriver = false}) async {
    final snap = await FirebaseFirestore.instance
        .collection('Booking_Details')
        .where(isDriver ? 'Driver UID' : 'Commuter UID', isEqualTo: uid)
        .get();
    return snap.docs.map((element) => element.data()).toList();
  }
}
