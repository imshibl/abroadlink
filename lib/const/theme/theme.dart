import 'package:abroadlink/const/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: ConstColors.mainBgColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: ConstColors.mainBgColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ConstColors.boxBgColor,
      selectedItemColor: Colors.grey.shade300,
      unselectedItemColor: Colors.grey,
    ),
  );
}
