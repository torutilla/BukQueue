// models/api_json_management/place_autocomplete_response.dart
import 'dart:convert';
import 'package:flutter_try_thesis/models/api_json_management/autocomplete_prediction.dart';

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;
  final String? errorMessage;

  PlaceAutocompleteResponse({this.status, this.predictions, this.errorMessage});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? (json['predictions'] as List)
              .map<AutocompletePrediction>((item) =>
                  AutocompletePrediction.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
      String responseBody) {
    final Map<String, dynamic> parsedJson = json.decode(responseBody);
    return PlaceAutocompleteResponse.fromJson(parsedJson);
  }
}
