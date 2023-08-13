import 'package:abroadlink/models/explore_users.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import '../../apis/home_api/home.api.dart';
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

  List<String> _alreadyFetchedUsersUIDs = [];

  Future<List<ExploreUsersModel>> paginateUsers(
      double userLat, double userLong, int maxDistance) async {
    try {
      // final FirebaseAuth auth = FirebaseAuth.instance;
      // final User? user = auth.currentUser;

      final user = authStreamProvider.value;

      final usersData = await exploreServices.paginateUsers(
          _alreadyFetchedUsersUIDs, user!.uid);

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

        if (distance <= maxDistance) {
          state = [...state, user];
          _alreadyFetchedUsersUIDs.add(user.uid.toString());
        }
      }

      state.removeWhere((user) =>
          user.distance > maxDistance &&
          _alreadyFetchedUsersUIDs.remove(user.uid.toString()));

      if (state.isEmpty) {
        _alreadyFetchedUsersUIDs = [
          FirebaseAuth.instance.currentUser!.uid,
        ];
      }
    } catch (e) {
      return Future.error(e);
    }
    return state;
  }
}
