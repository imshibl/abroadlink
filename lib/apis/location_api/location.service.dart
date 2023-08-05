// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
}
