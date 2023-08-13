import 'dart:async';

import 'package:abroadlink/models/current_user.model.dart';
import 'package:abroadlink/apis/user_api/user.api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userCountStreamProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, userId) {
  final update = ref.watch(userNotifierProvider.notifier).updateUserCounts();
  return update;
});

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserModel?>(
    (ref) => UserNotifier(userServices: ref.watch(userAPIServiceProvider)));

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier({required this.userServices})
      : super(UserModel(
          fullname: '',
          homeCountry: '',
          homeCountryCode: '',
          lat: 0,
          long: 0,
          phoneNumber: '',
          studyAbroadDestination: '',
          studyAbroadDestinationCode: '',
          createdAt: DateTime.now(),
          followers: [],
          following: [],
          geopoint: {},
        ));

  final UserAPIServices userServices;

  Future<UserModel?> getCurrentUserData() async {
    try {
      state = await userServices.getCurrentUserData();

      return state;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> updateUserName(String name) async {
    try {
      await userServices.updateUserName(name);
      state = state!.copyWith(fullname: name);
      return state;
    } catch (e) {
      return null;
    }
  }

  Stream<UserModel> updateUserCounts() {
    try {
      final stream = userServices.updateUserCounts();
      return stream.map((snapshot) {
        final data =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        state = state!
            .copyWith(followers: data.followers, following: data.following);

        return state!;
      });
    } catch (e) {
      return const Stream.empty();
    }
  }
}
