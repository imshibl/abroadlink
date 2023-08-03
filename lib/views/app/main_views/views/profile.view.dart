// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/config/colors.dart';
import 'package:abroadlink/notifiers/location_notifier/loc.notifier.dart';
import 'package:abroadlink/services/user_services/user.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../notifiers/auth_notifier/auth.notifier.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text(FirebaseAuth.instance.currentUser!.displayName!),
        backgroundColor: mainBgColor,
        actions: [
          IconButton(
            onPressed: () {
              final authServiceProvider = ref.read(authProvider.notifier);
              authServiceProvider.logout().then((value) => {
                    ref
                        .read(locationStateNotifierProvider.notifier)
                        .resetState(),
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/loginView", (route) => false)
                  });
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder(
          future: ref.read(userProvider).getCurrentUserData(),
          builder: ((context, snapshot) {
            final userData = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ProfileScreen(
                fullname: userData!.fullname.toString(),
                homeCountry: userData.homeCountry.toString(),
                studyAbroadDestination:
                    userData.studyAbroadDestination.toString());
          })),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String fullname;
  final String homeCountry;
  final String studyAbroadDestination;

  const ProfileScreen({
    super.key,
    required this.fullname,
    required this.homeCountry,
    required this.studyAbroadDestination,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80', // Replace with the user's photo URL
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
              Spacer(flex: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "0",
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Connections",
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 16,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CustomButton1(
                        text: "Explore",
                      ),
                      SizedBox(width: 5),
                      CustomButton1(text: "Edit Profile"),
                    ],
                  )
                ],
              ),
              Spacer()
            ],
          ),
          Text(
            fullname,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade200,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text("Home Country: $homeCountry",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade200,
                fontWeight: FontWeight.w400,
              )),
          Text("Study Abroad Destination: $studyAbroadDestination",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade200,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }
}

class CustomButton1 extends StatelessWidget {
  final String text;
  const CustomButton1({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      color: buttonColor,
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
