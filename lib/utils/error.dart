import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorAnimation extends StatelessWidget {
  const ErrorAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/error_animation.json', height: 80),
          const SizedBox(height: 10),
          const Text(
            "Something went wrong, we can't take off, try refreshing",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
