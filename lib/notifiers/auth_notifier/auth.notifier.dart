import 'package:abroadlink/apis/auth_api/auth.api.dart';
import 'package:abroadlink/utils/snackbar.dart';
import 'package:abroadlink/views/app/auth_views/verify_email.view.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/current_user.model.dart';

final authNotifierProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, bool>(
        (ref) => AuthNotifier(ref.watch(authAPIServiceProvider)));

class AuthNotifier extends StateNotifier<bool> {
  final AuthAPIServices _authServices;

  AuthNotifier(this._authServices) : super(false);

  Future<void> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      state = true;
      await _authServices.signIn(email, password).then((value) {
        Navigator.pushAndRemoveUntil(
            context, VerifyEmailView.route(), (route) => false);
      });
      state = false;
    } catch (e) {
      state = false;
      Utils.showSnackBar(context, message: e.toString());
    }
  }

  Future<void> registerWithEmailAndPassword(
      BuildContext context,
      String username,
      String email,
      String password,
      UserModel userModel) async {
    try {
      state = true;
      await _authServices
          .signUp(username, email, password, userModel)
          .then((value) {
        // print("data $value");
        Navigator.pushAndRemoveUntil(
            context, VerifyEmailView.route(), (route) => false);
      });

      state = false;
    } catch (e) {
      state = false;
      Utils.showSnackBar(context, message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _authServices.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfUsernameExists(String username) async {
    try {
      state = true;
      final data = await _authServices.isUsernameAvailable(username);
      state = false;
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      return await _authServices.isEmailIsAvailable(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserData() async {
    try {
      await _authServices.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }
}
