import 'package:abroadlink/models/current_user.model.dart';
import 'package:abroadlink/apis/user_api/user.api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final currentUserProvider = FutureProvider((ref) async {
//   final userServices = ref.watch(userProvider);
//   final userData = await userServices.getCurrentUserData();
//   return userData;
// });

final userNotifierProvider = StateNotifierProvider<UserNotifier, UserModel?>(
    (ref) => UserNotifier(userServices: ref.watch(userAPIServiceProvider)));

// final getCurrentUserData = FutureProvider<UserModel?>((ref) async {
//   final userServices = ref.watch(userProvider);
//   final userData = await userServices.getCurrentUserData();
//   return userData;
// });

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier({required this.userServices})
      : super(const UserModel(
            fullname: '',
            homeCountry: '',
            homeCountryCode: '',
            lat: 0,
            long: 0,
            phoneNumber: '',
            studyAbroadDestination: '',
            studyAbroadDestinationCode: ''));

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
}
