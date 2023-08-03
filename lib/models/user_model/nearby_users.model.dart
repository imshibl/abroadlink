class NearbyUsersModel {
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
  const NearbyUsersModel({
    this.username,
    this.uid,
    this.email,
    this.photoUrl,
    required this.homeCountryCode,
    required this.studyAbroadDestinationCode,
    required this.fullname,
    required this.phoneNumber,
    required this.homeCountry,
    required this.studyAbroadDestination,
    required this.lat,
    required this.long,
    required this.place,
    required this.distance,
  });
}
