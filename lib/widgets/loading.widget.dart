import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../const/styles/lotties.dart';
import '../utils/facts.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  String getRandomFact() {
    Random random = Random();
    int randomIndex = random.nextInt(facts.length);
    return facts[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(ConstLottieAnimations.loadingAnimation, height: 80),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              getRandomFact(),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
