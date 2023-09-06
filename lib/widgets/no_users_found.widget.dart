import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/views/app/main_views/views/explore/filter.view.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoUsersFoundAnimation extends StatelessWidget {
  const NoUsersFoundAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/loading_animation.json', height: 80),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "No users found, Try modifying your filters",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            elevation: 0,
            color: ConstColors.lightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () {
              Navigator.push(context, FilterView.route());
            },
            child: const Text(
              'Edit Filters',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
