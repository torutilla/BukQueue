import 'package:google_maps_flutter/google_maps_flutter.dart';

class TariffsClass {
  String placeName;
  LatLng locationLatLng;
  int price;
  String zone;
  String terminalName;
  TariffsClass({
    required this.placeName,
    required this.locationLatLng,
    required this.price,
    required this.zone,
    required this.terminalName,
  });
}
