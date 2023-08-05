import 'package:abroadlink/views/app/auth_views/login.view.dart';
import 'package:abroadlink/views/app/auth_views/verify_email.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF393053),
      body: Center(
        child: Image.asset(
          "assets/images/png/logo_no_bg.png",
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    );
  }
}
