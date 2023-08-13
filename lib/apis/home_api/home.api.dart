import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/explore_users.model.dart';
import '../../notifiers/location_notifier/location.notifier.dart';

final exploreAPIServiceProvider = Provider<ExploreAPIServices>((ref) {
  return ExploreAPIServices(
      locationNotifier: ref.watch(locationNotifierProvider.notifier),
      firebaseCollections: ref.watch(firebaseCollectionProvider));
});

abstract class IExploreAPIServices {
  // Future<List<ExploreUsersModel>> fetchNearbyUsers(
  //     {required double userLat,
  //     required double userLong,
  //     required int maxDistance});

  Future<ExploreUsersModel> fetchUserDetails(
      {required String uid, required double userLat, required double userLong});

  Future<QuerySnapshot> paginateUsers(
      List<String> alreadyLoadedUsersUIDList, String currentUserUid);
}

class ExploreAPIServices implements IExploreAPIServices {
  final LocationNotifier _locationNotifier;
  final FirebaseCollections _firebaseCollections;
  ExploreAPIServices({
    required LocationNotifier locationNotifier,
    required FirebaseCollections firebaseCollections,
  })  : _firebaseCollections = firebaseCollections,
        _locationNotifier = locationNotifier;

  @override
  Future<ExploreUsersModel> fetchUserDetails(
      {required String uid,
      required double userLat,
      required double userLong}) async {
    late String location;
    late double distance;
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

        distance = _locationNotifier.calculateDistance(userLat, userLong,
            value['lat'].toDouble(), value['long'].toDouble());
        return value;
      });

      return ExploreUsersModel.fromFirestore(doc, location, distance);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Object?>> paginateUsers(
      List<String> alreadyLoadedUsersUIDList, String currentUserUid) async {
    final QuerySnapshot querySnapshot = await _firebaseCollections
        .usersCollection
        .where('uid',
            whereNotIn: [currentUserUid, ...alreadyLoadedUsersUIDList])
        .orderBy('uid')
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot;
  }

  //  final CollectionReference<Map<String, dynamic>> collectionReference =
  //       FirebaseFirestore.instance.collection('users');

  //   GeoPoint geopointFrom(Map<String, dynamic> data) {
  //     return (data['geopoint'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
  //   }
  //   final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> stream =
  //       GeoCollectionReference<Map<String, dynamic>>(collectionReference)
  //           .subscribeWithin(
  //     center: GeoFirePoint(GeoPoint(userLat, userLong)),
  //     radiusInKm: 14,
  //     field: "geopoint",
  //     geopointFrom: geopointFrom,
  //     strictMode: true,
  //   );

  //   stream.listen((event) async {
  //     for (var doc in event) {
  //       if (doc['uid'] != FirebaseAuth.instance.currentUser!.uid) {
  //         List<Placemark> placemarks = await placemarkFromCoordinates(
  //             doc['lat'].toDouble(), doc['long'].toDouble());
  //         final city = placemarks.first.locality;
  //         final state = placemarks.first.administrativeArea;
  //         String location = "$city,$state";

  //         double distance = _locationNotifier.calculateDistance(
  //             userLat, userLong, doc['lat'].toDouble(), doc['long'].toDouble());
  //         ExploreUsersModel user2 =
  //             ExploreUsersModel.fromFirestore(doc, location, distance);

  //         nearbyUsers.add(user2);
  //       }
  //     }
  //   });
}
