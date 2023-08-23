import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import '../../models/explore_users.model.dart';
import '../../notifiers/location_notifier/location.notifier.dart';

final exploreAPIServiceProvider = Provider<ExploreAPIServices>((ref) {
  return ExploreAPIServices(
      locationNotifier: ref.watch(locationNotifierProvider.notifier),
      firebaseCollections: ref.watch(firebaseCollectionProvider));
});

abstract class IExploreAPIServices {
  Future<ExploreUsersModel> getUserProfileDetails(
      {required String uid, required double userLat, required double userLong});

  Future<QuerySnapshot> getUsersGlobally({
    required String currentUserUid,
    DocumentSnapshot? lastDocument,
    String? studyAbroadDestination,
    String? homeCountry,
  });

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getUsersLocally(
      String uid, double userLat, double userLong, int maxDistance);
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
  Future<ExploreUsersModel> getUserProfileDetails(
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
  Future<QuerySnapshot<Object?>> getUsersGlobally({
    required String currentUserUid,
    DocumentSnapshot? lastDocument,
    String? studyAbroadDestination,
    String? homeCountry,
  }) async {
    Query usersQuery = _firebaseCollections.usersCollection
        .where('uid', isNotEqualTo: currentUserUid)
        .orderBy('uid')
        .orderBy('createdAt', descending: true)
        .limit(5);

    if (lastDocument != null) {
      usersQuery = usersQuery.startAfterDocument(lastDocument);
    }
    if (studyAbroadDestination != null) {
      usersQuery = usersQuery.where('studyAbroadDestination',
          isEqualTo: studyAbroadDestination);
    }
    if (homeCountry != null) {
      usersQuery = usersQuery.where('homeCountry', isEqualTo: homeCountry);
    }

    final QuerySnapshot querySnapshot = await usersQuery.get();
    return querySnapshot;
  }

  @override
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getUsersLocally(
      String uid, double userLat, double userLong, int maxDistance) async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection('users');

    GeoPoint geopointFrom(Map<String, dynamic> data) {
      return (data['geopoint'] as Map<String, dynamic>)['geopoint'] as GeoPoint;
    }

    final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> usersStream =
        GeoCollectionReference<Map<String, dynamic>>(collectionReference)
            .subscribeWithin(
      center: GeoFirePoint(GeoPoint(userLat, userLong)),
      radiusInKm: maxDistance.toDouble(),
      field: "geopoint",
      geopointFrom: geopointFrom,
      strictMode: true,
    );

    final List<DocumentSnapshot<Map<String, dynamic>>> usersList =
        await usersStream.first;

    return usersList;
  }
}
