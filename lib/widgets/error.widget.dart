import 'package:abroadlink/const/styles/lotties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../notifiers/refresh_notifier/refresh_notifier.dart';

class ErrorAnimation extends ConsumerWidget {
  const ErrorAnimation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(ConstLottieAnimations.errorAnimation, height: 80),
          const SizedBox(height: 10),
          const Text(
            "Something went wrong, we can't take off, try refreshing",
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
              onPressed: () {
                ref.read(refreshNotifierProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh, color: Colors.white)),
        ],
      ),
    );
  }
}
