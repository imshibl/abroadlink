import 'package:abroadlink/const/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_views/login.view.dart';
import 'auth_views/verify_email.view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, VerifyEmailView.route());
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, LoginView.route());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          ConstImages.logoImage,
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    );
  }
}
