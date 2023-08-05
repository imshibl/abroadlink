import 'package:abroadlink/views/app/auth_views/forgot_pswd.view.dart';
import 'package:abroadlink/views/app/auth_views/login.view.dart';
import 'package:abroadlink/views/app/auth_views/signup.view.dart';
import 'package:abroadlink/views/app/auth_views/verify_email.view.dart';
import 'package:abroadlink/views/app/main_views/main.view.dart';
import 'package:flutter/material.dart';

import '../views/app/main_views/views/explore/filter.view.dart';

Map<String, Widget Function(BuildContext)> routes = {
  //auth
  '/loginView': (context) => const LoginView(),
  '/signupView': (context) => const SignupView(),
  '/forgotPasswordView': (context) => const ForgotPasswordView(),
  '/verifyEmailView': (context) => const VerifyEmailView(),

  //profile setup
  // '/setupProfileView': (context) => const SetupProfileView(),

  //main
  '/mainView': (context) => const MainView(),

  //explore
  '/filterView': (contet) => const FilterView(),
  // '/userProfileView': (context) => const UserProfileView(),
};
