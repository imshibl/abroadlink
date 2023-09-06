// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/widgets.dart';

// @immutable
// class ExploreUsersModel {
//   final String? username;
//   final String fullname;
//   final String? uid;
//   final String? email;
//   final String? photoUrl;
//   final String phoneNumber;
//   final String homeCountry;
//   final String homeCountryCode;
//   final String studyAbroadDestination;
//   final String studyAbroadDestinationCode;
//   final double lat;
//   final double long;
//   final String place;
//   final double distance;
//   const ExploreUsersModel({
//     this.username,
//     required this.fullname,
//     this.uid,
//     this.email,
//     this.photoUrl,
//     required this.phoneNumber,
//     required this.homeCountry,
//     required this.homeCountryCode,
//     required this.studyAbroadDestination,
//     required this.studyAbroadDestinationCode,
//     required this.lat,
//     required this.long,
//     required this.place,
//     required this.distance,
//   });

//   factory ExploreUsersModel.fromFirestore(
//       DocumentSnapshot doc, String place, double distance) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return ExploreUsersModel(
//       username: data['username'] != null ? data['username'] as String : null,
//       fullname: data['fullname'] as String,
//       uid: data['uid'] != null ? data['uid'] as String : null,
//       email: data['email'] != null ? data['email'] as String : null,
//       photoUrl: data['photoUrl'] != null ? data['photoUrl'] as String : null,
//       phoneNumber: data['phoneNumber'] as String,
//       homeCountry: data['homeCountry'] as String,
//       homeCountryCode: data['homeCountryCode'] as String,
//       studyAbroadDestination: data['studyAbroadDestination'] as String,
//       studyAbroadDestinationCode: data['studyAbroadDestinationCode'] as String,
//       lat: data['lat'] as double,
//       long: data['long'] as double,
//       place: place,
//       distance: distance,
//     );
//   }

//   ExploreUsersModel copyWith({
//     String? username,
//     String? fullname,
//     String? uid,
//     String? email,
//     String? photoUrl,
//     String? phoneNumber,
//     String? homeCountry,
//     String? homeCountryCode,
//     String? studyAbroadDestination,
//     String? studyAbroadDestinationCode,
//     double? lat,
//     double? long,
//     String? place,
//     double? distance,
//   }) {
//     return ExploreUsersModel(
//       username: username ?? this.username,
//       fullname: fullname ?? this.fullname,
//       uid: uid ?? this.uid,
//       email: email ?? this.email,
//       photoUrl: photoUrl ?? this.photoUrl,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       homeCountry: homeCountry ?? this.homeCountry,
//       homeCountryCode: homeCountryCode ?? this.homeCountryCode,
//       studyAbroadDestination:
//           studyAbroadDestination ?? this.studyAbroadDestination,
//       studyAbroadDestinationCode:
//           studyAbroadDestinationCode ?? this.studyAbroadDestinationCode,
//       lat: lat ?? this.lat,
//       long: long ?? this.long,
//       place: place ?? this.place,
//       distance: distance ?? this.distance,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'username': username,
//       'fullname': fullname,
//       'uid': uid,
//       'email': email,
//       'photoUrl': photoUrl,
//       'phoneNumber': phoneNumber,
//       'homeCountry': homeCountry,
//       'homeCountryCode': homeCountryCode,
//       'studyAbroadDestination': studyAbroadDestination,
//       'studyAbroadDestinationCode': studyAbroadDestinationCode,
//       'lat': lat,
//       'long': long,
//       'place': place,
//       'distance': distance,
//     };
//   }

//   factory ExploreUsersModel.fromMap(Map<String, dynamic> map) {
//     return ExploreUsersModel(
//       username: map['username'] != null ? map['username'] as String : null,
//       fullname: map['fullname'] as String,
//       uid: map['uid'] != null ? map['uid'] as String : null,
//       email: map['email'] != null ? map['email'] as String : null,
//       photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
//       phoneNumber: map['phoneNumber'] as String,
//       homeCountry: map['homeCountry'] as String,
//       homeCountryCode: map['homeCountryCode'] as String,
//       studyAbroadDestination: map['studyAbroadDestination'] as String,
//       studyAbroadDestinationCode: map['studyAbroadDestinationCode'] as String,
//       lat: map['lat'] as double,
//       long: map['long'] as double,
//       place: map['place'] as String,
//       distance: map['distance'] as double,
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class ExploreUsersModel {
  final String? username;
  final String? uid;
  final String? email;
  final String? photoUrl;
  final String fullname;
  final String phoneNumber;
  final String homeCountry;
  final String homeCountryCode;
  final String studyAbroadDestination;
  final String studyAbroadDestinationCode;
  final double lat;
  final double long;
  final String place;
  final double distance;
  final List<String> followers;
  final List<String> following;
  final Map<String, dynamic> geopoint;
  final DateTime createdAt;
  ExploreUsersModel({
    this.username,
    this.uid,
    this.email,
    this.photoUrl,
    required this.fullname,
    required this.phoneNumber,
    required this.homeCountry,
    required this.homeCountryCode,
    required this.studyAbroadDestination,
    required this.studyAbroadDestinationCode,
    required this.lat,
    required this.long,
    required this.place,
    required this.distance,
    required this.followers,
    required this.following,
    required this.geopoint,
    required this.createdAt,
  });

  ExploreUsersModel copyWith({
    String? username,
    String? uid,
    String? email,
    String? photoUrl,
    String? fullname,
    String? phoneNumber,
    String? homeCountry,
    String? homeCountryCode,
    String? studyAbroadDestination,
    String? studyAbroadDestinationCode,
    double? lat,
    double? long,
    String? place,
    double? distance,
    List<String>? followers,
    List<String>? following,
    Map<String, dynamic>? geopoint,
    DateTime? createdAt,
  }) {
    return ExploreUsersModel(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      fullname: fullname ?? this.fullname,
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
      followers: followers ?? this.followers,
      following: following ?? this.following,
      geopoint: geopoint ?? this.geopoint,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ExploreUsersModel.fromFirestore(
      DocumentSnapshot json, String place, double distance) {
    return ExploreUsersModel(
      username: json['username'] != null ? json['username'] as String : null,
      uid: json['uid'] != null ? json['uid'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      photoUrl: json['photoUrl'] != null ? json['photoUrl'] as String : null,
      fullname: json['fullname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      homeCountry: json['homeCountry'] as String,
      homeCountryCode: json['homeCountryCode'] as String,
      studyAbroadDestination: json['studyAbroadDestination'] as String,
      studyAbroadDestinationCode: json['studyAbroadDestinationCode'] as String,
      lat: json['lat'] as double,
      long: json['long'] as double,
      place: place,
      distance: distance,
      followers: json['followers'] != null
          ? List<String>.from(json['followers'] as List<dynamic>)
          : [],
      following: json['following'] != null
          ? List<String>.from(json['following'] as List<dynamic>)
          : [],
      geopoint: json['geopoint'] as Map<String, dynamic>,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json['createdAt'] as int,
            )
          : DateTime.now(),
    );
  }

  factory ExploreUsersModel.fromJson(Map<String, dynamic> json) {
    return ExploreUsersModel(
      username: json['username'] != null ? json['username'] as String : null,
      uid: json['uid'] != null ? json['uid'] as String : null,
      email: json['email'] != null ? json['email'] as String : null,
      photoUrl: json['photoUrl'] != null ? json['photoUrl'] as String : null,
      fullname: json['fullname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      homeCountry: json['homeCountry'] as String,
      homeCountryCode: json['homeCountryCode'] as String,
      studyAbroadDestination: json['studyAbroadDestination'] as String,
      studyAbroadDestinationCode: json['studyAbroadDestinationCode'] as String,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
      place: json['place'] as String,
      distance: (json['distance'] as num).toDouble(),
      followers: List<String>.from((json['followers'] as List<dynamic>)),
      following: List<String>.from((json['following'] as List<dynamic>)),
      geopoint:
          Map<String, dynamic>.from((json['geopoint'] as Map<String, dynamic>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'email': email,
      'photoUrl': photoUrl,
      'fullname': fullname,
      'phoneNumber': phoneNumber,
      'homeCountry': homeCountry,
      'homeCountryCode': homeCountryCode,
      'studyAbroadDestination': studyAbroadDestination,
      'studyAbroadDestinationCode': studyAbroadDestinationCode,
      'lat': lat,
      'long': long,
      'place': place,
      'distance': distance,
      'followers': followers,
      'following': following,
      'geopoint': geopoint,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ExploreUsersModel.fromMap(Map<String, dynamic> map) {
    return ExploreUsersModel(
      username: map['username'] != null ? map['username'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      fullname: map['fullname'] as String,
      phoneNumber: map['phoneNumber'] as String,
      homeCountry: map['homeCountry'] as String,
      homeCountryCode: map['homeCountryCode'] as String,
      studyAbroadDestination: map['studyAbroadDestination'] as String,
      studyAbroadDestinationCode: map['studyAbroadDestinationCode'] as String,
      lat: map['lat'] as double,
      long: map['long'] as double,
      place: map['place'] as String,
      distance: map['distance'] as double,
      followers: List<String>.from((map['followers'] as List<String>)),
      following: List<String>.from((map['following'] as List<String>)),
      geopoint:
          Map<String, dynamic>.from((map['geopoint'] as Map<String, dynamic>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
