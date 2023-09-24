import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../const/styles/lotties.dart';

class PaginationAnimation extends StatelessWidget {
  const PaginationAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Lottie.asset(ConstLottieAnimations.paginationAnimation, height: 80),
    );
  }
}
