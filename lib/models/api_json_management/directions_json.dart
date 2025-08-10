class PolylineResponse {
  final List<GeocodedWaypoints>? geocodedWaypoints;
  final List<Routes>? routes;
  final String? status;

  PolylineResponse({this.geocodedWaypoints, this.routes, this.status});

  factory PolylineResponse.fromJson(Map<String, dynamic> json) {
    return PolylineResponse(
      geocodedWaypoints: (json['geocoded_waypoints'] as List<dynamic>?)
          ?.map((v) => GeocodedWaypoints.fromJson(v))
          .toList(),
      routes: (json['routes'] as List<dynamic>?)
          ?.map((v) => Routes.fromJson(v))
          .toList(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geocoded_waypoints': geocodedWaypoints?.map((v) => v.toJson()).toList(),
      'routes': routes?.map((v) => v.toJson()).toList(),
      'status': status,
    };
  }
}

class GeocodedWaypoints {
  final String? geocoderStatus;
  final String? placeId;
  final List<String>? types;

  GeocodedWaypoints({this.geocoderStatus, this.placeId, this.types});

  factory GeocodedWaypoints.fromJson(Map<String, dynamic> json) {
    return GeocodedWaypoints(
      geocoderStatus: json['geocoder_status'] as String?,
      placeId: json['place_id'] as String?,
      types: (json['types'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'geocoder_status': geocoderStatus,
      'place_id': placeId,
      'types': types,
    };
  }
}

class Routes {
  final Bounds? bounds;
  final String? copyrights;
  final List<Legs>? legs;
  final PolylineModel? overviewPolyline;
  final String? summary;

  Routes({
    this.bounds,
    this.copyrights,
    this.legs,
    this.overviewPolyline,
    this.summary,
  });

  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      bounds: json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null,
      copyrights: json['copyrights'] as String?,
      legs: (json['legs'] as List<dynamic>?)
          ?.map((v) => Legs.fromJson(v))
          .toList(),
      overviewPolyline: json['overview_polyline'] != null
          ? PolylineModel.fromJson(json['overview_polyline'])
          : null,
      summary: json['summary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (bounds != null) 'bounds': bounds!.toJson(),
      'copyrights': copyrights,
      if (legs != null) 'legs': legs!.map((v) => v.toJson()).toList(),
      if (overviewPolyline != null)
        'overview_polyline': overviewPolyline!.toJson(),
      'summary': summary,
    };
  }
}

class Bounds {
  final Northeast? northeast;
  final Northeast? southwest;

  Bounds({this.northeast, this.southwest});

  factory Bounds.fromJson(Map<String, dynamic> json) {
    return Bounds(
      northeast: json['northeast'] != null
          ? Northeast.fromJson(json['northeast'])
          : null,
      southwest: json['southwest'] != null
          ? Northeast.fromJson(json['southwest'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (northeast != null) 'northeast': northeast!.toJson(),
      if (southwest != null) 'southwest': southwest!.toJson(),
    };
  }
}

class Northeast {
  final double? lat;
  final double? lng;

  Northeast({this.lat, this.lng});

  factory Northeast.fromJson(Map<String, dynamic> json) {
    return Northeast(
      lat: json['lat'] as double?,
      lng: json['lng'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Legs {
  final Distance? distance;
  final Distance? duration;
  final String? endAddress;
  final Northeast? endLocation;
  final String? startAddress;
  final Northeast? startLocation;
  final List<Steps>? steps;

  Legs({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
  });

  factory Legs.fromJson(Map<String, dynamic> json) {
    return Legs(
      distance:
          json['distance'] != null ? Distance.fromJson(json['distance']) : null,
      duration:
          json['duration'] != null ? Distance.fromJson(json['duration']) : null,
      endAddress: json['end_address'] as String?,
      endLocation: json['end_location'] != null
          ? Northeast.fromJson(json['end_location'])
          : null,
      startAddress: json['start_address'] as String?,
      startLocation: json['start_location'] != null
          ? Northeast.fromJson(json['start_location'])
          : null,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((v) => Steps.fromJson(v))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (distance != null) 'distance': distance!.toJson(),
      if (duration != null) 'duration': duration!.toJson(),
      'end_address': endAddress,
      if (endLocation != null) 'end_location': endLocation!.toJson(),
      'start_address': startAddress,
      if (startLocation != null) 'start_location': startLocation!.toJson(),
      if (steps != null) 'steps': steps!.map((v) => v.toJson()).toList(),
    };
  }
}

class Distance {
  final String? text;
  final int? value;

  Distance({this.text, this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'] as String?,
      value: json['value'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
    };
  }
}

class Steps {
  final Distance? distance;
  final Distance? duration;
  final Northeast? endLocation;
  final String? htmlInstructions;
  final PolylineModel? polyline;
  final Northeast? startLocation;
  final String? travelMode;
  final String? maneuver;

  Steps({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.polyline,
    this.startLocation,
    this.travelMode,
    this.maneuver,
  });

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      distance:
          json['distance'] != null ? Distance.fromJson(json['distance']) : null,
      duration:
          json['duration'] != null ? Distance.fromJson(json['duration']) : null,
      endLocation: json['end_location'] != null
          ? Northeast.fromJson(json['end_location'])
          : null,
      htmlInstructions: json['html_instructions'] as String?,
      polyline: json['polyline'] != null
          ? PolylineModel.fromJson(json['polyline'])
          : null,
      startLocation: json['start_location'] != null
          ? Northeast.fromJson(json['start_location'])
          : null,
      travelMode: json['travel_mode'] as String?,
      maneuver: json['maneuver'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (distance != null) 'distance': distance!.toJson(),
      if (duration != null) 'duration': duration!.toJson(),
      if (endLocation != null) 'end_location': endLocation!.toJson(),
      'html_instructions': htmlInstructions,
      if (polyline != null) 'polyline': polyline!.toJson(),
      if (startLocation != null) 'start_location': startLocation!.toJson(),
      'travel_mode': travelMode,
      'maneuver': maneuver,
    };
  }
}

class PolylineModel {
  final String? points;

  PolylineModel({this.points});

  factory PolylineModel.fromJson(Map<String, dynamic> json) {
    return PolylineModel(
      points: json['points'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
    };
  }
}
