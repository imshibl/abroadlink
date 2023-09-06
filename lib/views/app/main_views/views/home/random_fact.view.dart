import 'dart:math';

import 'package:abroadlink/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../utils/facts.dart';

class RandomFactView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const RandomFactView());
  const RandomFactView({super.key});

  @override
  State<RandomFactView> createState() => _RandomFactViewState();
}

class _RandomFactViewState extends State<RandomFactView> {
  int index = 0;

  getRandomFact() {
    Random random = Random();
    int randomIndex = random.nextInt(facts.length);
    setState(() {
      index = randomIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Facts'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/loading_animation.json', height: 100),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              facts[index],
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          MaterialButton(
            elevation: 0,
            color: ConstColors.lightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              getRandomFact();
            },
            child: const Text(
              'Get Random Fact',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
