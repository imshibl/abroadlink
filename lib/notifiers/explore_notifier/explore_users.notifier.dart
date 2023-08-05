import 'package:abroadlink/models/explore_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/explore_api/explore.api.dart';

final exploreUsersNotifierProvider =
    StateNotifierProvider<ExploreUsersNotifier, List<ExploreUsersModel>>(
        (ref) => ExploreUsersNotifier(
            exploreServices: ref.watch(exploreAPIServiceProvider)));

class ExploreUsersNotifier extends StateNotifier<List<ExploreUsersModel>> {
  ExploreUsersNotifier({required this.exploreServices}) : super([]);

  final ExploreAPIServices exploreServices;

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
