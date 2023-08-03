import 'package:abroadlink/models/user_model/nearby_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/explore_services/explore.service.dart';

import 'package:flutter/foundation.dart';

final usersProvider = ChangeNotifierProvider<UsersNotifier>((ref) {
  return UsersNotifier(ref.read(exploreProvider));
});

class UsersNotifier extends ChangeNotifier {
  final ExploreServices _userRepository;
  UsersNotifier(this._userRepository);

  List<NearbyUsersModel> _users = [];

  List<NearbyUsersModel> get users => _users;

  Future<List<NearbyUsersModel>> fetchNearbyUsers(
      double userLat, double userLong, int maxDistance) async {
    _users = await _userRepository.fetchNearbyUsers(
        userLat: userLat, userLong: userLong, maxDistance: maxDistance);

    return _users;
  }
}
