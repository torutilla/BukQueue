import 'dart:convert';
import 'package:flutter_try_thesis/constants/bounding_box.dart';
import 'package:flutter_try_thesis/constants/tagaytayCoordinates.dart';
import 'package:flutter_try_thesis/models/api_json_management/places_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_try_thesis/models/api_json_management/autocomplete_prediction.dart';
import 'package:flutter_try_thesis/models/api_json_management/directions_json.dart';
import 'package:flutter_try_thesis/models/api_json_management/place.dart';
import 'package:flutter_try_thesis/models/api_json_management/place_auto_complete_response.dart';
import 'package:flutter_try_thesis/models/http_request_files/httpUtility.dart';
import 'package:flutter_try_thesis/models/providers/bookingProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DirectionsClass {
  final BookingProvider bookingProvider;
  String getApiKey = dotenv.env['API_KEY'] ?? '';
  DirectionsClass(this.bookingProvider);

  List<LatLng> bookingPolyline = [];
  Future<void> getDirectionofLocation(LatLng origin, LatLng destination) async {
    // String apiKey = await getApiKey();
    String apiKey = getApiKey;
    Uri directionsApi = Uri.https(
      "maps.googleapis.com",
      "maps/api/directions/json",
      {
        "origin": '${origin.latitude},${origin.longitude}',
        "destination": '${destination.latitude},${destination.longitude}',
        "key": apiKey,
      },
    );

    var response = await HttpUtility.networkUtilityFetchUrl(directionsApi);
    handleResponse(response);
  }

  void decodePolyline(String polylineCode) {
    final polylinePoints = PolylinePoints().decodePolyline(polylineCode);
    final addPolyline =
        polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
    for (int i = 0; i < polylinePoints.length; i++) {
      bookingPolyline = addPolyline;
      bookingProvider.addToPolylineList(addPolyline[i]);
    }
  }

  void handleResponse(var response) {
    if (response != null) {
      final directionsResponse =
          PolylineResponse.fromJson(jsonDecode(response));

      final polylinePoints = PolylinePoints().decodePolyline(
          directionsResponse.routes![0].overviewPolyline!.points!);
      bookingProvider.polylineCode =
          directionsResponse.routes![0].overviewPolyline!.points!;
      final addPolyline =
          polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
      for (int i = 0; i < polylinePoints.length; i++) {
        bookingPolyline = addPolyline;
        bookingProvider.addToPolylineList(addPolyline[i]);
      }
    }
  }
}

class PlaceSuggestions {
  // final SuggestionsProvider suggestionsProvider;
  // PlaceSuggestions(this.suggestionsProvider); // Remove if not needed for this class

  final Uuid _uuid = const Uuid();
  String? _sessionToken;

  void startNewSession() {
    _sessionToken = _uuid.v4();
    print("New Places Autocomplete API session started: $_sessionToken");
  }

  void endSession() {
    _sessionToken = null;
    print("Places Autocomplete API session ended.");
  }

  Future<List<AutocompletePrediction>?> generateSuggestions(
    String input,
  ) async {
    if (_sessionToken == null) {
      startNewSession();
    }

    String getApiKey = dotenv.env['API_KEY'] ?? '';
    String apiKey = getApiKey;

    if (apiKey.isEmpty) {
      print("API Key is missing!");
      return null;
    }
    if (input.isEmpty) {
      endSession();
      startNewSession();
      return [];
    }

    List<LatLng> allServiceAreaPoints = [];
    barangayCoordinates.forEach((key, value) {
      allServiceAreaPoints.addAll(value);
    });
    final Map<String, double> serviceAreaBounds =
        getBoundingBox(allServiceAreaPoints);

    final Uri placesAutoCompleteUri =
        Uri.https("places.googleapis.com", "v1/places:autocomplete");

    final Map<String, dynamic> requestBody = {
      "input": input,
      "sessionToken": _sessionToken!,
      "includedRegionCodes": ["PH"],
      "locationRestriction": {
        "rectangle": {
          "low": {
            "latitude": serviceAreaBounds['south'],
            "longitude": serviceAreaBounds['west'],
          },
          "high": {
            "latitude": serviceAreaBounds['north'],
            "longitude": serviceAreaBounds['east'],
          }
        }
      },
    };

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
    };

    String? response = await HttpUtility.postUrl(
      placesAutoCompleteUri,
      requestBody,
      headers: headers,
    );

    if (response != null) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response);

      if (jsonResponse.containsKey('suggestions')) {
        List<AutocompletePrediction> predictions =
            (jsonResponse['suggestions'] as List)
                .map((e) => AutocompletePrediction.fromJson(e))
                .toList();
        return predictions;
      } else if (jsonResponse.containsKey('error')) {
        print(
            "Autocomplete API Error: ${jsonResponse['error']['status']} - ${jsonResponse['error']['message'] ?? 'Unknown error'}");
        return [];
      } else {
        print(
            "Autocomplete API did not return predictions or error: $response");
        return [];
      }
    }
    return null;
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId,
      {String? sessionToken}) async {
    String apiKey = dotenv.env['API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      print("API Key is missing for Place Details!");
      return null;
    }

    final String baseUrl = "https://places.googleapis.com/v1/places/$placeId";
    final Uri placeDetailsUri = Uri.parse(baseUrl);

    final String fieldMask = "formattedAddress,location,displayName";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-Goog-Api-Key": apiKey,
      "X-Goog-FieldMask": fieldMask,
    };

    if (sessionToken != null) {
      headers["X-Goog-Places-Session-Token"] = sessionToken;
      print("Place Details request with session token: $sessionToken");
    } else {
      print(
          "Place Details request without session token (e.g., for saved place).");
    }

    String? responseBody = await HttpUtility.networkUtilityFetchUrl(
      placeDetailsUri,
      headers: headers,
    );

    if (responseBody != null) {
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);

      if (jsonResponse.containsKey('error')) {
        print(
            "Place Details API Error: ${jsonResponse['error']['message'] ?? 'Unknown error from new API'}");

        if (sessionToken != null) {
          endSession();
        }
        return null;
      } else {
        if (sessionToken != null) {
          endSession();
        }

        return PlaceDetails.fromJson(jsonResponse);
      }
    }
    return null;
  }
}

// class PlaceSearch {
//   String getApiKey = dotenv.env['API_KEY'] ?? '';
//   Map<String, dynamic> addressWithLatLng = {};
//   Future<Map<String, dynamic>> generatePlaces(
//       String input, Position userLocation) async {
//     Uri placeTextSearch = Uri.https(
//       "maps.googleapis.com",
//       "maps/api/place/textsearch/json",
//       {
//         "fields": 'formatted_address,name,geometry',
//         "query": input,
//         "radius": '50',
//         "location": '${userLocation.latitude},${userLocation.longitude}',
//         "key": getApiKey,
//       },
//     );
//     String? response =
//         await HttpUtility.networkUtilityFetchUrl(placeTextSearch);
//     if (response != null) {
//       PlaceTextSearch textSearchResponse =
//           PlaceTextSearch.parsePlaceTextSearch(response);

//       if (textSearchResponse.results != null) {
//         for (int i = 0; i < textSearchResponse.results!.length; i++) {
//           addressWithLatLng[textSearchResponse.results![i].name!] =
//               textSearchResponse.results![i].locationGeometry!.latLng;
//         }
//       }
//     }
//     return addressWithLatLng;
//   }
// }

class DistanceMatrix {
  Future<void> getDistance(List<LatLng> pickup, List<LatLng> dropoff) async {
    String getApiKey = dotenv.env['API_KEY'] ?? '';
    final url =
        'https://routes.googleapis.com/distanceMatrix/v2:computeRouteMatrix';
    final body = {
      'origins': pickup
          .map((origin) => {
                'waypoint': {
                  'location': {
                    'latlng': {
                      'latitude': origin.latitude,
                      'longitude': origin.longitude,
                    }
                  }
                }
              })
          .toList(),
      'destinations': dropoff
          .map((destination) => {
                'waypoint': {
                  'location': {
                    'latlng': {
                      'latitude': destination.latitude,
                      'longitude': destination.longitude,
                    }
                  }
                }
              })
          .toList(),
      'travelMode': 'DRIVING',
      'routingPreference': 'TRAFFIC_AWARE',
    };
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': getApiKey,
            'X-Goog-FieldMask':
                'originIndex,destinationIndex,duration,distanceMeters',
          },
          body: jsonEncode(body));
    } catch (e) {}
  }
}
