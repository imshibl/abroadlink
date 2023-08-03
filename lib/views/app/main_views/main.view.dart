// ignore_for_file: prefer_const_constructors

import 'package:abroadlink/config/colors.dart';
import 'package:abroadlink/views/app/main_views/views/explore.view.dart';
import 'package:abroadlink/views/app/main_views/views/profile.view.dart';
import 'package:abroadlink/views/app/main_views/views/search.view.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;
  List<Widget> views = [
    ExploreView(),
    SearchView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: boxBgColor,
        selectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
