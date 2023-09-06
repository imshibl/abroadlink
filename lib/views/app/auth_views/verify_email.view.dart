// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:abroadlink/providers/firebase.provider.dart';
import 'package:abroadlink/views/app/main_views/main.view.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmailView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const VerifyEmailView());
  const VerifyEmailView({super.key});

  @override
  ConsumerState<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends ConsumerState<VerifyEmailView> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong.Try again")));
    }
  }

  Future checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmailVerified) timer?.cancel();
    } catch (_) {}
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final authStream = ref.watch(authStateStreamProvider);
    return authStream.when(data: (user) {
      if (user != null && !user.emailVerified) {
        return const MainView();
      } else {
        return const Text("email not varified");
      }
    }, error: (object, stackTrace) {
      return const Scaffold(
        body: Center(
          child: Text("Error"),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
    // return isEmailVerified
    //     ? const MainView()
    //     : Scaffold(
    //         backgroundColor: mainBgColor,
    //         body: Padding(
    //           padding: const EdgeInsets.only(left: 10, right: 10),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "A verification email has been sent to your email",
    //                 style: GoogleFonts.montserrat(
    //                     fontSize: 18, color: Colors.white),
    //                 textAlign: TextAlign.center,
    //               ),
    //               const SizedBox(height: 10),
    //               Text(
    //                 "${FirebaseAuth.instance.currentUser!.email}",
    //                 style: GoogleFonts.poppins(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w500,
    //                     color: Colors.white),
    //               ),
    //               const SizedBox(height: 20),
    //               ElevatedButton.icon(
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: buttonColor,
    //                 ),
    //                 onPressed: canResendEmail ? sendVerificationEmail : null,
    //                 icon: const Icon(Icons.email),
    //                 label: Text(
    //                   "Resend Email",
    //                   style: GoogleFonts.poppins(color: Colors.white),
    //                 ),
    //               ),
    //               TextButton(
    //                 onPressed: () async {
    //                   // await FirebaseAuth.instance.signOut().then((value) {
    //                   //   Navigator.pushNamedAndRemoveUntil(
    //                   //       context, "/loginView", (route) => false);
    //                   // });
    //                   final authServiceProvider =
    //                       ref.read(authProvider.notifier);
    //                   await authServiceProvider.deleteUserData().then((value) {
    //                     Navigator.pushNamedAndRemoveUntil(
    //                         context, "/loginView", (route) => false);
    //                   });
    //                 },
    //                 child: Text(
    //                   "Cancel",
    //                   style: GoogleFonts.poppins(color: Colors.white),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
  }
}
