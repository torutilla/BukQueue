import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceTextSearch {
  final List<PlaceResult>? results;

  PlaceTextSearch({this.results});

  factory PlaceTextSearch.fromJson(Map<String, dynamic> json) {
    return PlaceTextSearch(
      results: (json['results'] as List)
          .map((e) => PlaceResult.fromJson(e))
          .toList(),
    );
  }

  static PlaceTextSearch parsePlaceTextSearch(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<String, dynamic>();
    return PlaceTextSearch.fromJson(parsed);
  }
}

class PlaceResult {
  final String? formattedAddress;
  final String? name;
  final LocationDetails? locationGeometry;

  PlaceResult({
    this.formattedAddress,
    this.name,
    this.locationGeometry,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) {
    return PlaceResult(
      formattedAddress: json['formatted_address'] as String?,
      name: json['name'] as String?,
      locationGeometry: json['geometry'] != null
          ? LocationDetails.fromJson(json['geometry']['location'])
          : null,
    );
  }
}

class LocationDetails {
  final LatLng latLng;

  LocationDetails({required this.latLng});

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    return LocationDetails(
      latLng: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lng'] as num).toDouble(),
      ),
    );
  }
}
