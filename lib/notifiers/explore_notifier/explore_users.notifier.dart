import 'package:abroadlink/models/explore_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/explore_api/explore.api.dart';
import '../location_notifier/location.notifier.dart';

final exploreUsersNotifierProvider =
    StateNotifierProvider<ExploreUsersNotifier, List<ExploreUsersModel>>((ref) {
  final exploreUNotifier = ExploreUsersNotifier(
      locationNotifier: ref.watch(locationNotifierProvider.notifier),
      exploreServices: ref.watch(exploreAPIServiceProvider));
  // exploreUNotifier.initUsers(
  //   userLat: ref.watch(locationNotifierProvider).lat,
  //   userLong: ref.watch(locationNotifierProvider).long,
  // );
  return exploreUNotifier;
});

class ExploreUsersNotifier extends StateNotifier<List<ExploreUsersModel>> {
  ExploreUsersNotifier(
      {required this.exploreServices, required this.locationNotifier})
      : super([]);

  final ExploreAPIServices exploreServices;
  final LocationNotifier locationNotifier;

  Future<List<ExploreUsersModel>> fetchNearbyUsers(
      double userLat, double userLong, int maxDistance) async {
    try {
      state = await exploreServices.fetchNearbyUsers(
          userLat: userLat, userLong: userLong, maxDistance: maxDistance);
    } catch (e) {
      return Future.error(e);
    }
    return state;
  }
}
