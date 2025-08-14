import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class Booking {
  final BookingLocation pickup;
  final BookingLocation dropoff;
  Booking(this.pickup, this.dropoff);
  Map<String, dynamic> map();
  void extractFromMap(Map<String, dynamic> bookingMap);
}

class DriverBooking extends Booking {
  final String bookingId;
  final String passengerName;
  final String photoLink;
  final String number;
  DriverBooking(
    this.bookingId,
    this.photoLink,
    this.passengerName,
    this.number,
    super.pickup,
    super.dropoff,
  );

  @override
  Map<String, dynamic> map() {
    return {};
  }

  @override
  void extractFromMap(Map<String, dynamic> bookingMap) {
    //
  }
}

class CommuterBooking extends Booking {
  String uid;
  String name;
  String contactNumber;
  String status;
  String polylineCode;
  int passengerCount;
  int price;
  String notes;
  String terminal;
  String zone;
  Timestamp timestamp;
  CommuterBooking(
    super.pickup,
    super.dropoff,
    this.status,
    this.uid,
    this.name,
    this.contactNumber,
    this.polylineCode,
    this.passengerCount,
    this.price,
    this.notes,
    this.terminal,
    this.zone,
    this.timestamp,
  );
  @override
  Map<String, dynamic> map() {
    return {
      "Zone": zone,
      "Terminal": terminal,
      "Pickup Location": pickup.address,
      "Dropoff Location": dropoff.address,
      "Pickup LatLng": pickup.coordinates,
      "Dropoff LatLng": dropoff.coordinates,
      "Polyline Code": polylineCode,
      "Booking Status": "For Booking",
      "Time Stamp": timestamp,
      "Passenger Count": passengerCount,
      "Price": price,
      "Note": notes,
      "Commuter UID": uid,
      "Commuter Name": name,
      "Contact Number": contactNumber,
    };
  }

  @override
  void extractFromMap(Map<String, dynamic> bookingMap) {
    // TODO: implement extractFromMap
  }
}

class BookingLocation {
  final String address;
  final LatLng coordinates;
  BookingLocation(
    this.address,
    this.coordinates,
  );
}
