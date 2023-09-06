import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaginationAnimation extends StatelessWidget {
  const PaginationAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Lottie.asset('assets/lottie/pagination_animation.json', height: 80),
    );
  }
}
