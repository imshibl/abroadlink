import 'package:abroadlink/notifiers/location_notifier/location.notifier.dart';
import 'package:abroadlink/views/app/main_views/views/home.view.dart';
import 'package:abroadlink/views/app/main_views/views/profile.view.dart';
import 'package:abroadlink/views/app/main_views/views/chats.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../notifiers/refresh_notifier/refresh_notifier.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  void initState() {
    super.initState();
    ref.read(locationNotifierProvider.notifier).getLocation();
  }

  int currentIndex = 0;
  List<Widget> views = [
    const HomeView(),
    const ChatView(),
    const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    ref.watch(refreshNotifierProvider); //
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: views,
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
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: "Chats"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
