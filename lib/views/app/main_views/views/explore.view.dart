// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/config/colors.dart';
import 'package:abroadlink/models/explore_users.model.dart';
import 'package:abroadlink/views/app/main_views/views/explore/user_profile.view.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../notifiers/explore_notifier/explore_users.notifier.dart';
import '../../../../notifiers/location_notifier/location.notifier.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  @override
  Widget build(BuildContext context) {
    final locationNotifier = ref.read(locationNotifierProvider.notifier);
    return FutureBuilder(
        future: locationNotifier.getLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          }

          return Scaffold(
            backgroundColor: mainBgColor,
            appBar: AppBar(
              title: Text("AbroadLink"),
              backgroundColor: mainBgColor,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chat),
                ),
              ],
            ),
            body: Consumer(builder: (context, ref, _) {
              final locationNotifier2 = ref.watch(locationNotifierProvider);

              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                style: GoogleFonts.poppins(color: Colors.white),
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Location',
                                  fillColor: boxBgColor,
                                  filled: true,
                                  isDense: true,
                                  hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey.shade400),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: boxBgColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: buttonColor,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: boxBgColor),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: buttonColor,
                                    ),
                                  ),
                                ),
                                controller: TextEditingController(
                                    text: locationNotifier2.isFetchingLocation
                                        ? "Fetching Your Location..."
                                        : locationNotifier2.place),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: boxBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(left: 10, right: 5),
                            child: IconButton(
                              icon:
                                  Icon(Icons.location_pin, color: Colors.white),
                              onPressed: () {
                                locationNotifier.updateLocation();
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: boxBgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: IconButton(
                              icon: Icon(Icons.filter_alt, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 10),
                        child: Text(
                          "Explore People",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                          future: ref
                              .read(exploreUsersNotifierProvider.notifier)
                              .fetchNearbyUsers(locationNotifier2.lat,
                                  locationNotifier2.long, 500),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.data!.isEmpty) {
                              return Center(child: Text("No Users Found"));
                            }
                            final nearbyUsers = snapshot.data;
                            nearbyUsers!.sort(
                                (a, b) => a.distance.compareTo(b.distance));
                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: nearbyUsers.length,
                              itemBuilder: (context, index) {
                                ExploreUsersModel user = nearbyUsers[index];
                                return UsersCard(
                                  username: user.username!,
                                  distance: user.distance,
                                  isKm: ref
                                      .read(locationNotifierProvider.notifier)
                                      .shouldDisplayInKilometers(user.distance),
                                  place: user.place,
                                  homeCountryCode: user.homeCountryCode,
                                  studyAbroadDestinationCode:
                                      user.studyAbroadDestinationCode,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      UserProfileView.route(
                                        selectedUserUID: user.uid.toString(),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ],
              );
            }),
          );
        });
  }
}

class UsersCard extends StatelessWidget {
  final String username;
  final double distance;
  final bool isKm;
  final String place;
  final String homeCountryCode;
  final String studyAbroadDestinationCode;
  final Function() onTap;
  const UsersCard(
      {super.key,
      required this.username,
      required this.distance,
      required this.place,
      required this.homeCountryCode,
      required this.studyAbroadDestinationCode,
      required this.onTap,
      required this.isKm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 35,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              username,
              style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountryFlag.fromCountryCode(
                  homeCountryCode,
                  height: 23,
                  width: 23,
                  borderRadius: 3,
                ),
                Text(
                  "  to  ",
                  style: TextStyle(
                      color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                ),
                CountryFlag.fromCountryCode(
                  studyAbroadDestinationCode,
                  height: 23,
                  width: 23,
                  borderRadius: 3,
                ),
              ],
            ),
            // Text(
            //   place,
            //   style: TextStyle(
            //     color: Colors.grey.shade200,
            //     fontSize: 8,
            //   ),
            // ),
            Text(
              isKm ? "${distance.toStringAsFixed(2)} km" : "within 1 km",
              // : "${(distance * 1000).toStringAsFixed(2)} m",
              style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
