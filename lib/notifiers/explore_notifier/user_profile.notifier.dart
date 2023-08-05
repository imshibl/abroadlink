import 'package:abroadlink/models/user_model/nearby_users.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../apis/explore_services/explore.service.dart';

final exploreUserProfileNotifier =
    StateNotifierProvider<ExploreUserProfileNotifier, NearbyUsersModel>((ref) {
  return ExploreUserProfileNotifier(
      exploreServices: ref.watch(exploreProvider));
});

// final getSelectedUserDataNotifier =
//     FutureProvider.family<NearbyUsersModel, String>((ref, uid) async {
//   final userProfileProvider = ref.watch(exploreUserProfileNotifier.notifier);
//   return userProfileProvider.fetchSelectedUserData(selectedUserUID: uid);
// });

class ExploreUserProfileNotifier extends StateNotifier<NearbyUsersModel> {
  ExploreUserProfileNotifier({required this.exploreServices})
      : super(const NearbyUsersModel(
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

  final ExploreServices exploreServices;

  Future<NearbyUsersModel> fetchSelectedUserData(
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
