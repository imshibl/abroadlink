import 'package:flutter/widgets.dart';

@immutable
class UserModel {
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
  const UserModel({
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      fullname: json['fullname'],
      uid: json['uid'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      phoneNumber: json['phoneNumber'],
      homeCountry: json['homeCountry'],
      homeCountryCode: json['homeCountryCode'],
      studyAbroadDestination: json['studyAbroadDestination'],
      studyAbroadDestinationCode: json['studyAbroadDestinationCode'],
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
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
    };
  }

  UserModel copyWith({
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
  }) {
    return UserModel(
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
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
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
    );
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.uid == uid &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.fullname == fullname &&
        other.phoneNumber == phoneNumber &&
        other.homeCountry == homeCountry &&
        other.homeCountryCode == homeCountryCode &&
        other.studyAbroadDestination == studyAbroadDestination &&
        other.studyAbroadDestinationCode == studyAbroadDestinationCode &&
        other.lat == lat &&
        other.long == long;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        fullname.hashCode ^
        phoneNumber.hashCode ^
        homeCountry.hashCode ^
        homeCountryCode.hashCode ^
        studyAbroadDestination.hashCode ^
        studyAbroadDestinationCode.hashCode ^
        lat.hashCode ^
        long.hashCode;
  }
}
