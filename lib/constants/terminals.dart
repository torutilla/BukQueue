import 'package:google_maps_flutter/google_maps_flutter.dart';

class Terminals {
  final String zone;
  final LatLng coordinates;
  final String terminalName;
  Terminals(
      {required this.zone,
      required this.coordinates,
      required this.terminalName});
}
