import 'package:abroadlink/notifiers/connection/connection.notifer.dart';
import 'package:abroadlink/notifiers/location_notifier/location.notifier.dart';
import 'package:abroadlink/utils/snackbar.dart';
import 'package:abroadlink/views/app/main_views/views/home.view.dart';
import 'package:abroadlink/views/app/main_views/views/profile.view.dart';
import 'package:abroadlink/views/app/main_views/views/chats.view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
    ref.watch(refreshNotifierProvider);
    final connectivity = ref.watch(connectivityProvider);

    // Show a snackbar whenever the connectivity state changes

    connectivity.whenData((value) {
      if (value == ConnectivityResult.none) {
        Utils.showSnackBar(context,
            message: "No Internet Connection", color: Colors.red);
      }
    });

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
