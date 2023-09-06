// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class FilterUsersModel {
  final bool showLocalUsersOnly;
  final int radius;
  final bool sortByDistance;
  final String? homeCountry;
  final String? destinationCountry;
  const FilterUsersModel({
    required this.showLocalUsersOnly,
    required this.radius,
    required this.sortByDistance,
    this.homeCountry,
    this.destinationCountry,
  });

  FilterUsersModel copyWith({
    bool? showLocalUsersOnly,
    int? radius,
    bool? sortByDistance,
    String? homeCountry,
    String? destinationCountry,
  }) {
    return FilterUsersModel(
      showLocalUsersOnly: showLocalUsersOnly ?? this.showLocalUsersOnly,
      radius: radius ?? this.radius,
      sortByDistance: sortByDistance ?? this.sortByDistance,
      homeCountry: homeCountry ?? this.homeCountry,
      destinationCountry: destinationCountry ?? this.destinationCountry,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showLocalUsersOnly': showLocalUsersOnly,
      'radius': radius,
      'sortByDistance': sortByDistance,
      'homeCountry': homeCountry,
      'destinationCountry': destinationCountry,
    };
  }

  factory FilterUsersModel.fromMap(Map<String, dynamic> map) {
    return FilterUsersModel(
      showLocalUsersOnly: map['showLocalUsersOnly'] as bool,
      radius: map['radius'] as int,
      sortByDistance: map['sortByDistance'] as bool,
      homeCountry:
          map['homeCountry'] != null ? map['homeCountry'] as String : null,
      destinationCountry: map['destinationCountry'] != null
          ? map['destinationCountry'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FilterUsersModel.fromJson(String source) =>
      FilterUsersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FilterUsersModel(showLocalUsersOnly: $showLocalUsersOnly, radius: $radius, sortByDistance: $sortByDistance, homeCountry: $homeCountry, destinationCountry: $destinationCountry)';
  }

  @override
  bool operator ==(covariant FilterUsersModel other) {
    if (identical(this, other)) return true;

    return other.showLocalUsersOnly == showLocalUsersOnly &&
        other.radius == radius &&
        other.sortByDistance == sortByDistance &&
        other.homeCountry == homeCountry &&
        other.destinationCountry == destinationCountry;
  }

  @override
  int get hashCode {
    return showLocalUsersOnly.hashCode ^
        radius.hashCode ^
        sortByDistance.hashCode ^
        homeCountry.hashCode ^
        destinationCountry.hashCode;
  }
}
