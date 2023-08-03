import 'package:abroadlink/services/user_services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifierProvider = ChangeNotifierProvider<UserNotifier>(
    (ref) => UserNotifier(userServices: ref.read(userProvider)));

class UserNotifier extends ChangeNotifier {
  UserServices userServices;
  UserNotifier({required this.userServices});

  Future fetchUserData() async {
    final userData = await userServices.getCurrentUserData();
    return userData;
  }
}
