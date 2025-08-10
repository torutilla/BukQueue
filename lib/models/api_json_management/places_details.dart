import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails {
  final String formattedAddress;
  final LatLng coordinates;
  final String? name;

  PlaceDetails({
    required this.formattedAddress,
    required this.coordinates,
    this.name,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      formattedAddress: json['formattedAddress'] as String,
      coordinates: LatLng(
        json['location']['latitude'] as double,
        json['location']['longitude'] as double,
      ),
      name: json['displayName']?['text'] as String?,
    );
  }
}
