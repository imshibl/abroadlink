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
  final List<String> followers;
  final List<String> following;
  final Map<String, dynamic> geopoint;
  final DateTime createdAt;
  UserModel({
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
    required this.followers,
    required this.following,
    required this.geopoint,
    required this.createdAt,
  });

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
    List<String>? followers,
    List<String>? following,
    Map<String, dynamic>? geopoint,
    DateTime? createdAt,
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
      followers: followers ?? this.followers,
      following: following ?? this.following,
      geopoint: geopoint ?? this.geopoint,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      'followers': followers,
      'following': following,
      'geopoint': geopoint,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
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
      followers: List<String>.from((map['followers'] as List<String>)),
      following: List<String>.from((map['following'] as List<String>)),
      geopoint:
          Map<String, dynamic>.from((map['geopoint'] as Map<String, dynamic>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
