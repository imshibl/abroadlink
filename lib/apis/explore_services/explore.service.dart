// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:abroadlink/apis/location_services/location.service.dart';
import '../../models/user_model/nearby_users.model.dart';

final exploreProvider = Provider<ExploreServices>((ref) {
  return ExploreServices(
      locationServices: ref.watch(locationServiceProvider),
      firebaseCollections: ref.watch(firebaseProvider));
});

abstract class IExploreAPIServices {
  Future<List<NearbyUsersModel>> fetchNearbyUsers(
      {required double userLat,
      required double userLong,
      required int maxDistance});

  Future<NearbyUsersModel> fetchUserDetails(
      {required String uid, required double userLat, required double userLong});
}

class ExploreServices implements IExploreAPIServices {
  final LocationServices _locationServices;
  final FirebaseCollections _firebaseCollections;
  ExploreServices({
    required LocationServices locationServices,
    required FirebaseCollections firebaseCollections,
  })  : _firebaseCollections = firebaseCollections,
        _locationServices = locationServices;

  @override
  Future<List<NearbyUsersModel>> fetchNearbyUsers(
      {required double userLat,
      required double userLong,
      required int maxDistance}) async {
    final QuerySnapshot querySnapshot =
        await _firebaseCollections.usersCollection.get();
    final List<NearbyUsersModel> nearbyUsers = [];

    for (var doc in querySnapshot.docs) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          doc['lat'].toDouble(), doc['long'].toDouble());
      final city = placemarks.first.locality;
      final state = placemarks.first.administrativeArea;
      String location = "$city,$state";

      int distance = _locationServices.calculateDistance(
          userLat, userLong, doc['lat'].toDouble(), doc['long'].toDouble());

      NearbyUsersModel user = NearbyUsersModel(
        username: doc['username'],
        fullname: doc['fullname'],
        uid: doc['uid'],
        email: doc['email'],
        photoUrl: doc['photoUrl'],
        phoneNumber: doc['phoneNumber'],
        homeCountry: doc['homeCountry'],
        homeCountryCode: doc['homeCountryCode'],
        studyAbroadDestinationCode: doc['studyAbroadDestinationCode'],
        studyAbroadDestination: doc['studyAbroadDestination'],
        lat: doc['lat'].toDouble(),
        long: doc['long'].toDouble(),
        place: location,
        distance: distance,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        if (user.uid != FirebaseAuth.instance.currentUser!.uid &&
            distance <= maxDistance) {
          nearbyUsers.add(user);
        }
      }
    }

    return nearbyUsers;
  }

  @override
  Future<NearbyUsersModel> fetchUserDetails(
      {required String uid,
      required double userLat,
      required double userLong}) async {
    late String location;
    late int distance;
    try {
      final DocumentSnapshot doc = await _firebaseCollections.usersCollection
          .doc(uid)
          .get()
          .then((value) async {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            value['lat'].toDouble(), value['long'].toDouble());
        final city = placemarks.first.locality;
        final state = placemarks.first.administrativeArea;
        location = "$city,$state";

        distance = _locationServices.calculateDistance(userLat, userLong,
            value['lat'].toDouble(), value['long'].toDouble());
        return value;
      });

      return NearbyUsersModel.fromFirestore(doc, location, distance);
    } catch (e) {
      rethrow;
    }
  }
}
