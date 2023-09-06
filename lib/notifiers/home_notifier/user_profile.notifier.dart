import 'package:abroadlink/models/explore_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/home_api/home.api.dart';

final exploreUserProfileNotifierProvider =
    StateNotifierProvider<ExploreUserProfileNotifier, ExploreUsersModel>((ref) {
  return ExploreUserProfileNotifier(
      exploreServices: ref.watch(exploreAPIServiceProvider));
});

class ExploreUserProfileNotifier extends StateNotifier<ExploreUsersModel> {
  ExploreUserProfileNotifier({required this.exploreServices})
      : super(ExploreUsersModel(
          fullname: '',
          phoneNumber: '',
          homeCountry: '',
          homeCountryCode: '',
          studyAbroadDestination: '',
          studyAbroadDestinationCode: '',
          lat: 0,
          long: 0,
          place: '',
          distance: 0,
          followers: [],
          following: [],
          geopoint: {},
          createdAt: DateTime.now(),
        ));

  final ExploreAPIServices exploreServices;

  Future<ExploreUsersModel> fetchSelectedUserData(
      {required String selectedUserUID,
      required double userLat,
      required double userLong}) async {
    try {
      state = await exploreServices.getUserProfileDetails(
          uid: selectedUserUID, userLat: userLat, userLong: userLong);
    } catch (e) {
      return Future.error(e);
    }
    return state;
  }
}
