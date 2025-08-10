import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceCacheSql {
  String placeId;
  String pickupLocation;
  String dropoffLocation;
  LatLng pickupLatLng;
  LatLng dropoffLatLng;
  String polyline;
  String bookingID;
  String date;
  String time;

  PlaceCacheSql({
    this.placeId = '',
    this.pickupLocation = '',
    this.dropoffLocation = '',
    this.polyline = '',
    this.pickupLatLng = const LatLng(0, 0),
    this.dropoffLatLng = const LatLng(0, 0),
    this.bookingID = '',
    this.date = '',
    this.time = '',
  });

  Map<String, Object?> mapBooking() {
    return {
      'id': bookingID,
      'Pickup_Location': pickupLocation,
      'Dropoff_Location': dropoffLocation,
      'Pickup_Lat': pickupLatLng.latitude,
      'Pickup_Lng': pickupLatLng.longitude,
      'Dropoff_Lat': dropoffLatLng.latitude,
      'Dropoff_Lng': dropoffLatLng.longitude,
      'Polyline': polyline,
      'Date': date,
      'Time': time,
    };
  }

  Map<String, Object?> mapSavedPlace() {
    return {
      'PlaceID': placeId,
      'Location': pickupLocation,
      'Location_Lat': pickupLatLng.latitude,
      'Location_Lng': pickupLatLng.longitude,
    };
  }
}
