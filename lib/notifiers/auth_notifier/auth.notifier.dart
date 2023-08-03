import 'package:abroadlink/services/auth_services/auth.service.dart';
import 'package:abroadlink/utils/snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model/current_user.model.dart';

final authProvider = StateNotifierProvider.autoDispose<AuthProvider, bool>(
    (ref) => AuthProvider(ref.read(authServiceProvider)));

class AuthProvider extends StateNotifier<bool> {
  final AuthServices _authServices;

  AuthProvider(this._authServices) : super(false);

  Future<void> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      state = true;
      await _authServices.signIn(email, password).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, "/verifyEmailView", (route) => false);
      });
      state = false;
    } catch (e) {
      state = false;
      showSnackBar(context, message: e.toString());
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
        Navigator.pushNamedAndRemoveUntil(
            context, "/verifyEmailView", (route) => false);
      });

      state = false;
    } catch (e) {
      state = false;
      showSnackBar(context, message: e.toString());
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
      return await _authServices.isUsernameAvailable(username);
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
