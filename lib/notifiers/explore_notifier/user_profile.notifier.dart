import 'package:abroadlink/models/explore_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/explore_api/explore.api.dart';

final exploreUserProfileNotifierProvider =
    StateNotifierProvider<ExploreUserProfileNotifier, ExploreUsersModel>((ref) {
  return ExploreUserProfileNotifier(
      exploreServices: ref.watch(exploreAPIServiceProvider));
});

// final getSelectedUserDataNotifier =
//     FutureProvider.family<NearbyUsersModel, String>((ref, uid) async {
//   final userProfileProvider = ref.watch(exploreUserProfileNotifier.notifier);
//   return userProfileProvider.fetchSelectedUserData(selectedUserUID: uid);
// });

class ExploreUserProfileNotifier extends StateNotifier<ExploreUsersModel> {
  ExploreUserProfileNotifier({required this.exploreServices})
      : super(const ExploreUsersModel(
            fullname: '',
            phoneNumber: '',
            homeCountry: '',
            homeCountryCode: '',
            studyAbroadDestination: '',
            studyAbroadDestinationCode: '',
            lat: 0,
            long: 0,
            place: '',
            distance: 0));

  final ExploreAPIServices exploreServices;

  Future<ExploreUsersModel> fetchSelectedUserData(
      {required String selectedUserUID,
      required double userLat,
      required double userLong}) async {
    try {
      state = await exploreServices.fetchUserDetails(
          uid: selectedUserUID, userLat: userLat, userLong: userLong);
    } catch (e) {
      return Future.error(e);
    }
    return state;
  }
}
