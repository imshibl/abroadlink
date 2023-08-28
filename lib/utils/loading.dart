import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'facts.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key, this.height});

  final double? height;

  String getRandomFact() {
    Random random = Random();
    int randomIndex = random.nextInt(facts.length);
    return facts[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/loading_animation.json', height: 70),
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
