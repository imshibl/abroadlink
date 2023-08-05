// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationServiceProvider = Provider<LocationServices>(
  (ref) => LocationServices(
    firebaseCollections: ref.watch(firebaseProvider),
  ),
);

abstract class ILocationAPIServices {
  Future getLocation();
  Future updateLocation(double lat, double long);
  int calculateDistance(double lat1, double lon1, double lat2, double lon2);
}

class LocationServices implements ILocationAPIServices {
  FirebaseCollections firebaseCollections;
  LocationServices({
    required this.firebaseCollections,
  });
  @override
  Future getLocation() async {
    try {
      final user = await firebaseCollections.usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateLocation(double lat, double long) async {
    try {
      return await firebaseCollections.usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "lat": lat,
        "long": long,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  int calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int R = 6371; // Earth's radius in km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c;
    int distanceInKm = distance.round();
    return distanceInKm;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
