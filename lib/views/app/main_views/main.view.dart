import 'package:abroadlink/views/app/main_views/views/home.view.dart';
import 'package:abroadlink/views/app/main_views/views/profile.view.dart';
import 'package:abroadlink/views/app/main_views/views/explore.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notifiers/refresh_notifier/refresh_notifier.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  int currentIndex = 0;
  List<Widget> views = [
    const HomeView(),
    const ExploreView(),
    const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    ref.watch(refreshNotifierProvider); //
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(refreshNotifierProvider.notifier).refresh();
          return Future.delayed(const Duration(seconds: 1));
        },
        child: IndexedStack(
          index: currentIndex,
          children: views,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Forum"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
