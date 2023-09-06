import 'package:abroadlink/notifiers/home_notifier/user_profile.notifier.dart';
import 'package:abroadlink/notifiers/location_notifier/location.notifier.dart';
import 'package:abroadlink/widgets/customButton1.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileView extends ConsumerWidget {
  static route({required String selectedUserUID}) => MaterialPageRoute(
      builder: (_) => UserProfileView(
            selectedUserUID: selectedUserUID,
          ));
  const UserProfileView({required this.selectedUserUID, super.key});

  final String selectedUserUID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationNotifier = ref.read(locationNotifierProvider);
    return FutureBuilder(
        future: ref
            .read(exploreUserProfileNotifierProvider.notifier)
            .fetchSelectedUserData(
                selectedUserUID: selectedUserUID,
                userLat: locationNotifier.lat,
                userLong: locationNotifier.long),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          } else if (snapshot.hasError) {
            return const ProfileErrorView();
          }
          final userData = snapshot.data;
          return OthersProfileView(
              fullname: userData!.fullname,
              userName: userData.username.toString(),
              homeCountry: userData.homeCountry,
              studyAbroadDestination: userData.studyAbroadDestination);
        });
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Error fetching user data",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class OthersProfileView extends StatelessWidget {
  final String fullname;
  final String userName;
  final String homeCountry;
  final String studyAbroadDestination;

  const OthersProfileView({
    super.key,
    required this.fullname,
    required this.homeCountry,
    required this.studyAbroadDestination,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
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
                const Spacer(flex: 2),
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
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        CustomButton1(
                          text: "Connect",
                        ),
                        SizedBox(width: 5),
                        CustomButton1(text: "Message"),
                      ],
                    )
                  ],
                ),
                const Spacer()
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
            const SizedBox(height: 5),
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
      ),
    );
  }
}
