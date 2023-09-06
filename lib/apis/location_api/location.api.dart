// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

final locationAPIServiceProvider = Provider<LocationAPIServices>(
  (ref) => LocationAPIServices(
    firebaseCollections: ref.watch(firebaseCollectionProvider),
  ),
);

abstract class ILocationAPIServices {
  Future getLocation();
  Future updateLocation(double lat, double long);
}

class LocationAPIServices implements ILocationAPIServices {
  FirebaseCollections firebaseCollections;
  LocationAPIServices({
    required this.firebaseCollections,
  });
  @override
  Future getLocation() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;

      final userData =
          await firebaseCollections.usersCollection.doc(user!.uid).get();

      return userData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateLocation(double lat, double long) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      return await firebaseCollections.usersCollection.doc(user!.uid).update({
        "lat": lat,
        "long": long,
        "geopoint": GeoFirePoint(GeoPoint(lat, long)).data,
      });
    } catch (e) {
      rethrow;
    }
  }
}
