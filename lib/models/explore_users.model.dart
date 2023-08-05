// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

@immutable
class ExploreUsersModel {
  final String? username;
  final String fullname;
  final String? uid;
  final String? email;
  final String? photoUrl;
  final String phoneNumber;
  final String homeCountry;
  final String homeCountryCode;
  final String studyAbroadDestination;
  final String studyAbroadDestinationCode;
  final double lat;
  final double long;
  final String place;
  final int distance;
  const ExploreUsersModel({
    this.username,
    required this.fullname,
    this.uid,
    this.email,
    this.photoUrl,
    required this.phoneNumber,
    required this.homeCountry,
    required this.homeCountryCode,
    required this.studyAbroadDestination,
    required this.studyAbroadDestinationCode,
    required this.lat,
    required this.long,
    required this.place,
    required this.distance,
  });

  factory ExploreUsersModel.fromFirestore(
      DocumentSnapshot doc, String place, int distance) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExploreUsersModel(
      username: data['username'] != null ? data['username'] as String : null,
      fullname: data['fullname'] as String,
      uid: data['uid'] != null ? data['uid'] as String : null,
      email: data['email'] != null ? data['email'] as String : null,
      photoUrl: data['photoUrl'] != null ? data['photoUrl'] as String : null,
      phoneNumber: data['phoneNumber'] as String,
      homeCountry: data['homeCountry'] as String,
      homeCountryCode: data['homeCountryCode'] as String,
      studyAbroadDestination: data['studyAbroadDestination'] as String,
      studyAbroadDestinationCode: data['studyAbroadDestinationCode'] as String,
      lat: data['lat'] as double,
      long: data['long'] as double,
      place: place,
      distance: distance,
    );
  }

  ExploreUsersModel copyWith({
    String? username,
    String? fullname,
    String? uid,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    String? homeCountry,
    String? homeCountryCode,
    String? studyAbroadDestination,
    String? studyAbroadDestinationCode,
    double? lat,
    double? long,
    String? place,
    int? distance,
  }) {
    return ExploreUsersModel(
      username: username ?? this.username,
      fullname: fullname ?? this.fullname,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeCountry: homeCountry ?? this.homeCountry,
      homeCountryCode: homeCountryCode ?? this.homeCountryCode,
      studyAbroadDestination:
          studyAbroadDestination ?? this.studyAbroadDestination,
      studyAbroadDestinationCode:
          studyAbroadDestinationCode ?? this.studyAbroadDestinationCode,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      place: place ?? this.place,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'fullname': fullname,
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'homeCountry': homeCountry,
      'homeCountryCode': homeCountryCode,
      'studyAbroadDestination': studyAbroadDestination,
      'studyAbroadDestinationCode': studyAbroadDestinationCode,
      'lat': lat,
      'long': long,
      'place': place,
      'distance': distance,
    };
  }

  factory ExploreUsersModel.fromMap(Map<String, dynamic> map) {
    return ExploreUsersModel(
      username: map['username'] != null ? map['username'] as String : null,
      fullname: map['fullname'] as String,
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      phoneNumber: map['phoneNumber'] as String,
      homeCountry: map['homeCountry'] as String,
      homeCountryCode: map['homeCountryCode'] as String,
      studyAbroadDestination: map['studyAbroadDestination'] as String,
      studyAbroadDestinationCode: map['studyAbroadDestinationCode'] as String,
      lat: map['lat'] as double,
      long: map['long'] as double,
      place: map['place'] as String,
      distance: map['distance'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExploreUsersModel.fromJson(String source) =>
      ExploreUsersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NearbyUsersModel(username: $username, fullname: $fullname, uid: $uid, email: $email, photoUrl: $photoUrl, phoneNumber: $phoneNumber, homeCountry: $homeCountry, homeCountryCode: $homeCountryCode, studyAbroadDestination: $studyAbroadDestination, studyAbroadDestinationCode: $studyAbroadDestinationCode, lat: $lat, long: $long, place: $place, distance: $distance)';
  }

  @override
  bool operator ==(covariant ExploreUsersModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.fullname == fullname &&
        other.uid == uid &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.phoneNumber == phoneNumber &&
        other.homeCountry == homeCountry &&
        other.homeCountryCode == homeCountryCode &&
        other.studyAbroadDestination == studyAbroadDestination &&
        other.studyAbroadDestinationCode == studyAbroadDestinationCode &&
        other.lat == lat &&
        other.long == long &&
        other.place == place &&
        other.distance == distance;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        fullname.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        phoneNumber.hashCode ^
        homeCountry.hashCode ^
        homeCountryCode.hashCode ^
        studyAbroadDestination.hashCode ^
        studyAbroadDestinationCode.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        place.hashCode ^
        distance.hashCode;
  }
}
