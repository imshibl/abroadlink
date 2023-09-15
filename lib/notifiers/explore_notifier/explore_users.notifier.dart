import 'package:abroadlink/models/explore_users.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../../apis/explore_api/explore.api.dart';
import '../../providers/firebase.provider.dart';
import '../location_notifier/location.notifier.dart';

final exploreUsersNotifierProvider =
    StateNotifierProvider<ExploreUsersNotifier, List<ExploreUsersModel>>((ref) {
  final exploreUNotifier = ExploreUsersNotifier(
    locationNotifier: ref.watch(locationNotifierProvider.notifier),
    exploreServices: ref.watch(exploreAPIServiceProvider),
    authStreamProvider: ref.watch(authStateStreamProvider),
  );
  return exploreUNotifier;
});

class ExploreUsersNotifier extends StateNotifier<List<ExploreUsersModel>> {
  ExploreUsersNotifier(
      {required this.exploreServices,
      required this.locationNotifier,
      required this.authStreamProvider})
      : super([]);

  final ExploreAPIServices exploreServices;
  final LocationNotifier locationNotifier;

  final AsyncValue<User?> authStreamProvider;

  late DocumentSnapshot _lastDocument;
  bool isLoadingMoreData = false;

  Future<List<ExploreUsersModel>> getInitialUsersGlobally({
    required double userLat,
    required double userLong,
    String? studyAbroadDestination,
    String? homeCountry,
  }) async {
    try {
      final user = authStreamProvider.value;

      final usersData = await exploreServices.getUsersGlobally(
          currentUserUid: user!.uid,
          studyAbroadDestination: studyAbroadDestination,
          homeCountry: homeCountry);

      _lastDocument = usersData.docs.last;

      final List<ExploreUsersModel> tempList = [];

      for (var doc in usersData.docs) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            doc['lat'].toDouble(), doc['long'].toDouble());
        final city = placemarks.first.locality;
        final statePlace = placemarks.first.administrativeArea;
        String location = "$city,$statePlace";

        double distance = locationNotifier.calculateDistance(
            userLat, userLong, doc['lat'].toDouble(), doc['long'].toDouble());

        ExploreUsersModel user =
            ExploreUsersModel.fromFirestore(doc, location, distance);
        tempList.add(user);
      }

      state = tempList;
    } catch (e) {
      if (e is StateError || state.isEmpty) {
        return [];
      }
      return Future.error(e);
    }
    return state;
  }

  getNextUsersGlobally({
    required double userLat,
    required double userLong,
    String? studyAbroadDestination,
    String? homeCountry,
  }) async {
    final List<ExploreUsersModel> tempList = [];
    try {
      state = [...state];
      isLoadingMoreData = true;
      final user = authStreamProvider.value;

      final usersData = await exploreServices.getUsersGlobally(
          currentUserUid: user!.uid,
          lastDocument: _lastDocument,
          studyAbroadDestination: studyAbroadDestination,
          homeCountry: homeCountry);

      _lastDocument = usersData.docs.last;

      for (var doc in usersData.docs) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            doc['lat'].toDouble(), doc['long'].toDouble());
        final city = placemarks.first.locality;
        final statePlace = placemarks.first.administrativeArea;
        String location = "$city,$statePlace";

        double distance = locationNotifier.calculateDistance(
            userLat, userLong, doc['lat'].toDouble(), doc['long'].toDouble());

        ExploreUsersModel user =
            ExploreUsersModel.fromFirestore(doc, location, distance);
        tempList.add(user);
      }

      state = [...state, ...tempList];
      isLoadingMoreData = false;
    } catch (e) {
      state = [...state, ...tempList];
      isLoadingMoreData = false;
      // return null;
    }
  }

  final List<String> _fetchedLocalUsersData = [];
  final int limit = 8;

  Future<List<ExploreUsersModel>> getInitialUsersLocally(
      {required double userlat,
      required double userlong,
      required int maxDistance,
      String? destinationCountry}) async {
    try {
      final currentUser = authStreamProvider.value;
      final data = await exploreServices.getUsersLocally(
          currentUser!.uid, userlat, userlong, maxDistance);

      final List<ExploreUsersModel> tempUsers = [];
      _fetchedLocalUsersData.clear();

      for (var doc in data) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            doc['lat'].toDouble(), doc['long'].toDouble());
        final city = placemarks.first.locality;
        final statePlace = placemarks.first.administrativeArea;
        String location = "$city,$statePlace";

        double distance = locationNotifier.calculateDistance(
            userlat, userlong, doc['lat'].toDouble(), doc['long'].toDouble());

        ExploreUsersModel userdata =
            ExploreUsersModel.fromFirestore(doc, location, distance);

        //no filter applied
        if (tempUsers.length < limit &&
            userdata.uid != currentUser.uid &&
            userdata.distance <= maxDistance &&
            destinationCountry == null) {
          tempUsers.add(userdata);
          _fetchedLocalUsersData.add(userdata.uid.toString());
        }
        //destination filter applied

        if (destinationCountry != null &&
            userdata.studyAbroadDestination == destinationCountry &&
            userdata.distance <= maxDistance &&
            userdata.uid != currentUser.uid) {
          tempUsers.add(userdata);
          _fetchedLocalUsersData.add(userdata.uid.toString());
        }
      }

      if (destinationCountry != null) {
        tempUsers.removeWhere(
            (element) => element.studyAbroadDestination != destinationCountry);
      }

      tempUsers.removeWhere((element) => element.distance > maxDistance);

      state = tempUsers;
    } catch (e) {
      return Future.error(e);
    }
    return state;
  }

  getNextUsersLocally(double userlat, double userlong, int maxDistance) async {
    try {
      state = [...state];
      isLoadingMoreData = true;
      final currentUser = authStreamProvider.value;
      final data = await exploreServices.getUsersLocally(
          currentUser!.uid, userlat, userlong, maxDistance);

      final List<ExploreUsersModel> tempUsers = [];

      for (var doc in data) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            doc['lat'].toDouble(), doc['long'].toDouble());
        final city = placemarks.first.locality;
        final statePlace = placemarks.first.administrativeArea;
        String location = "$city,$statePlace";

        double distance = locationNotifier.calculateDistance(
            userlat, userlong, doc['lat'].toDouble(), doc['long'].toDouble());

        ExploreUsersModel userdata =
            ExploreUsersModel.fromFirestore(doc, location, distance);

        if (tempUsers.length < limit &&
            !_fetchedLocalUsersData.contains(userdata.uid) &&
            userdata.uid != currentUser.uid) {
          tempUsers.add(userdata);
          _fetchedLocalUsersData.add(userdata.uid.toString());
        }
      }

      state = [...state, ...tempUsers];
      isLoadingMoreData = false;
    } catch (e) {
      isLoadingMoreData = false;
      rethrow;
    }
  }

  pullToRefresh() {
    state = [];
  }
}
