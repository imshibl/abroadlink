// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LocationModel {
  final double lat;
  final double long;
  final String place;
  final bool isLocationFetched;
  final bool isFetchingLocation;
  final bool hasError;

  LocationModel({
    required this.lat,
    required this.long,
    required this.place,
    required this.isLocationFetched,
    required this.isFetchingLocation,
    required this.hasError,
  });

  LocationModel copyWith({
    double? lat,
    double? long,
    String? place,
    bool? isLocationFetched,
    bool? isFetchingLocation,
    bool? hasError,
  }) {
    return LocationModel(
      lat: lat ?? this.lat,
      long: long ?? this.long,
      place: place ?? this.place,
      isLocationFetched: isLocationFetched ?? this.isLocationFetched,
      isFetchingLocation: isFetchingLocation ?? this.isFetchingLocation,
      hasError: hasError ?? this.hasError,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lat': lat,
      'long': long,
      'place': place,
      'isLocationFetched': isLocationFetched,
      'isFetchingLocation': isFetchingLocation,
      'hasError': hasError,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      lat: map['lat'] as double,
      long: map['long'] as double,
      place: map['place'] as String,
      isLocationFetched: map['isLocationFetched'] as bool,
      isFetchingLocation: map['isFetchingLocation'] as bool,
      hasError: map['hasError'] as bool,
    );
  }

  // String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocationModel(lat: $lat, long: $long, place: $place, isLocationFetched: $isLocationFetched, isFetchingLocation: $isFetchingLocation, hasError: $hasError)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.lat == lat &&
        other.long == long &&
        other.place == place &&
        other.isLocationFetched == isLocationFetched &&
        other.isFetchingLocation == isFetchingLocation &&
        other.hasError == hasError;
  }

  @override
  int get hashCode {
    return lat.hashCode ^
        long.hashCode ^
        place.hashCode ^
        isLocationFetched.hashCode ^
        isFetchingLocation.hashCode ^
        hasError.hashCode;
  }
}
