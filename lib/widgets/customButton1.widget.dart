import 'package:flutter/material.dart';

import '../const/colors.dart';

class CustomButton1 extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const CustomButton1({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      color: ConstColors.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade200,
          fontSize: 14,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
