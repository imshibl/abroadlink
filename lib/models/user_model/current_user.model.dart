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
      'fullname': fullname,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'homeCountry': homeCountry,
      'homeCountryCode': homeCountryCode,
      'studyAbroadDestinationCode': studyAbroadDestinationCode,
      'studyAbroadDestination': studyAbroadDestination,
      'lat': lat,
      'long': long,
    };
  }
}
