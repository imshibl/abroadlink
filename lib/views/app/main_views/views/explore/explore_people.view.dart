// ignore_for_file: prefer_const_constructors

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/notifiers/explore_notifier/filter_users.notifier.dart';
import 'package:abroadlink/views/app/main_views/views/explore/filter.view.dart';
import 'package:abroadlink/widgets/error.widget.dart';
import 'package:abroadlink/widgets/loading.widget.dart';
import 'package:abroadlink/widgets/no_users_found.widget.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/explore_users.model.dart';
import '../../../../../notifiers/explore_notifier/explore_users.notifier.dart';
import '../../../../../notifiers/location_notifier/location.notifier.dart';
import '../../../../../notifiers/refresh_notifier/refresh_notifier.dart';
import '../../../../../widgets/pagination.widget.dart';
import 'user_profile.view.dart';

class ExplorePeopleView extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ExplorePeopleView());
  const ExplorePeopleView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExplorePeopleViewState();
}

class _ExplorePeopleViewState extends ConsumerState<ExplorePeopleView> {
  final ScrollController _globalUsersScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _globalUsersScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _globalUsersScrollController.dispose();
  }

  void _scrollListener() {
    if (_globalUsersScrollController.position.pixels ==
        _globalUsersScrollController.position.maxScrollExtent) {
      // User has scrolled to the bottom
      final locationNotifier2 = ref.watch(locationNotifierProvider);
      final filterNotifer = ref.watch(filterUsersNotifierProvider);

      if (filterNotifer.showLocalUsersOnly) {
        ref.read(exploreUsersNotifierProvider.notifier).getNextUsersLocally(
              locationNotifier2.lat,
              locationNotifier2.long,
              filterNotifer.radius,
            );
      } else {
        ref.read(exploreUsersNotifierProvider.notifier).getNextUsersGlobally(
            userLat: locationNotifier2.lat,
            userLong: locationNotifier2.long,
            studyAbroadDestination: filterNotifer.destinationCountry,
            homeCountry: filterNotifer.homeCountry);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(refreshNotifierProvider); //listen to refresh notifier

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore People"),
      ),
      body: Consumer(builder: (context, ref, _) {
        final locationNotifier = ref.watch(locationNotifierProvider);
        final filterNotifer = ref.watch(filterUsersNotifierProvider);

        return ListView(
          controller: _globalUsersScrollController,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        filterNotifer.showLocalUsersOnly
                            ? "People Nearby"
                            : "People Around the World",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: ConstColors.boxBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: IconButton(
                          icon:
                              const Icon(Icons.filter_alt, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, FilterView.route());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                //show local users
                filterNotifer.showLocalUsersOnly
                    ? Consumer(builder: (context, ref, _) {
                        return FutureBuilder(
                            future: ref
                                .read(exploreUsersNotifierProvider.notifier)
                                .getInitialUsersLocally(
                                  userlat: locationNotifier.lat,
                                  userlong: locationNotifier.long,
                                  maxDistance: filterNotifer.radius,
                                  destinationCountry:
                                      filterNotifer.destinationCountry,
                                ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingAnimation();
                              } else if (snapshot.hasError) {
                                return const ErrorAnimation();
                              } else if (snapshot.data!.isEmpty) {
                                return const NoUsersFoundAnimation();
                              }

                              return Consumer(builder: (context, ref, _) {
                                final usersData =
                                    ref.watch(exploreUsersNotifierProvider);
                                final isLoadingMoreData = ref
                                    .watch(
                                        exploreUsersNotifierProvider.notifier)
                                    .isLoadingMoreData;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.9,
                                      ),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: usersData.length,
                                      itemBuilder: (context, index) {
                                        ExploreUsersModel user =
                                            usersData[index];
                                        return UsersCard(
                                          username: user.username!,
                                          distance: user.distance,
                                          isKm: ref
                                              .read(locationNotifierProvider
                                                  .notifier)
                                              .shouldDisplayInKilometers(
                                                  user.distance),
                                          place: user.place,
                                          isLocal:
                                              filterNotifer.showLocalUsersOnly,
                                          homeCountryCode: user.homeCountryCode,
                                          studyAbroadDestinationCode:
                                              user.studyAbroadDestinationCode,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              UserProfileView.route(
                                                selectedUserUID:
                                                    user.uid.toString(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Visibility(
                                        visible: isLoadingMoreData,
                                        child: PaginationAnimation()),
                                  ],
                                );
                              });
                            });
                      })
                    //show global users
                    : Consumer(builder: (context, ref, _) {
                        return FutureBuilder(
                            future: ref
                                .read(exploreUsersNotifierProvider.notifier)
                                .getInitialUsersGlobally(
                                    userLat: locationNotifier.lat,
                                    userLong: locationNotifier.long,
                                    studyAbroadDestination:
                                        filterNotifer.destinationCountry,
                                    homeCountry: filterNotifer.homeCountry),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingAnimation();
                              } else if (snapshot.hasError) {
                                return const ErrorAnimation();
                              } else if (snapshot.data!.isEmpty) {
                                return const NoUsersFoundAnimation();
                              }

                              return Consumer(builder: (context, ref, _) {
                                final usersData =
                                    ref.watch(exploreUsersNotifierProvider);
                                final isLoadingMoreData = ref
                                    .watch(
                                        exploreUsersNotifierProvider.notifier)
                                    .isLoadingMoreData;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.9,
                                      ),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: usersData.length,
                                      itemBuilder: (context, index) {
                                        ExploreUsersModel user =
                                            usersData[index];
                                        return UsersCard(
                                          username: user.username!,
                                          distance: user.distance,
                                          isKm: ref
                                              .read(locationNotifierProvider
                                                  .notifier)
                                              .shouldDisplayInKilometers(
                                                  user.distance),
                                          place: user.place,
                                          isLocal:
                                              filterNotifer.showLocalUsersOnly,
                                          homeCountryCode: user.homeCountryCode,
                                          studyAbroadDestinationCode:
                                              user.studyAbroadDestinationCode,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              UserProfileView.route(
                                                selectedUserUID:
                                                    user.uid.toString(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Visibility(
                                        visible: isLoadingMoreData,
                                        child: PaginationAnimation()),
                                  ],
                                );
                              });
                            });
                      }),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class UsersCard extends StatelessWidget {
  final String username;
  final double distance;
  final bool isKm;
  final String place;
  final String homeCountryCode;
  final String studyAbroadDestinationCode;
  final bool isLocal;
  final Function() onTap;
  const UsersCard(
      {super.key,
      required this.username,
      required this.distance,
      required this.place,
      required this.homeCountryCode,
      required this.studyAbroadDestinationCode,
      required this.onTap,
      required this.isKm,
      required this.isLocal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ConstColors.lightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 35,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
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
            isLocal
                ? Text(
                    isKm ? "${distance.toStringAsFixed(2)} km" : "within 1 km",
                    style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  )
                : Text(
                    place,
                    style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 14,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
