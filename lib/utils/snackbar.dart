import 'package:flutter/material.dart';

showSnackBar(BuildContext context, {required String message, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color ?? Colors.red,
    ),
  );
}
