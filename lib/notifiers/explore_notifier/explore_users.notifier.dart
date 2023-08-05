import 'package:abroadlink/models/user_model/nearby_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../apis/explore_services/explore.service.dart';

final exploreUsersProvider =
    StateNotifierProvider<ExploreUsersNotifier, List<NearbyUsersModel>>((ref) =>
        ExploreUsersNotifier(exploreServices: ref.watch(exploreProvider)));

class ExploreUsersNotifier extends StateNotifier<List<NearbyUsersModel>> {
  ExploreUsersNotifier({required this.exploreServices}) : super([]);

  final ExploreServices exploreServices;

  Future<List<NearbyUsersModel>> fetchNearbyUsers(
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
