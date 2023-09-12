// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/notifiers/auth_notifier/auth.notifier.dart';
import 'package:abroadlink/notifiers/user_notifier/user.notifier.dart';
import 'package:abroadlink/views/app/auth_views/login.view.dart';
import 'package:abroadlink/views/app/main_views/views/explore/explore_people.view.dart';
import 'package:abroadlink/widgets/error.widget.dart';
import 'package:abroadlink/widgets/loading.widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../notifiers/location_notifier/location.notifier.dart';
import '../../../../widgets/customButton1.widget.dart';
import 'profile/edit_profile.view.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late ValueNotifier<int> _tabIndexNotifier;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
    _tabIndexNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _tabIndexNotifier = ValueNotifier(0);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            _tabIndexNotifier.value = 0;

            break;
          case 1:
            _tabIndexNotifier.value = 1;
            break;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(FirebaseAuth.instance.currentUser!.displayName!),
        actions: [
          IconButton(
            onPressed: () {
              _openBottomSheet(context);
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: FutureBuilder(
          future: ref.read(userNotifierProvider.notifier).getCurrentUserData(),
          builder: ((context, snapshot) {
            final userData = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingAnimation());
            } else if (snapshot.hasError) {
              return const ErrorAnimation();
            }

            return ListView(
              shrinkWrap: true,
              children: [
                CurrentUserProfileView(
                  fullname: userData!.fullname.toString(),
                  homeCountry: userData.homeCountry.toString(),
                  studyAbroadDestination:
                      userData.studyAbroadDestination.toString(),
                  followers: userData.followers.length,
                  following: userData.following.length,
                ),
                const Divider(
                  color: ConstColors.lightColor,
                  thickness: 1,
                ),
                ValueListenableBuilder(
                    valueListenable: _tabIndexNotifier,
                    builder: (context, index, _) {
                      return Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            indicatorColor: ConstColors.lightColor,
                            onTap: (tabIndex) {
                              _tabIndexNotifier.value = tabIndex;
                              _pageController.animateToPage(
                                tabIndex,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            tabs: [
                              Tab(
                                icon: Icon(Icons.grid_3x3),
                              ),
                              Tab(
                                icon: Icon(Icons.bookmark_border),
                              ),
                            ],
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                // Update the ValueNotifier when the page changes
                                _tabIndexNotifier.value = page;
                              },
                              children: [
                                Center(child: Text("Posts")),
                                Center(child: Text("Saved Posts")),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            );
          })),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: ConstColors.boxBgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  final authServiceProvider =
                      ref.read(authNotifierProvider.notifier);
                  authServiceProvider.logout().then((value) => {
                        ref
                            .read(locationNotifierProvider.notifier)
                            .resetState(),
                        Navigator.pushAndRemoveUntil(
                            context, LoginView.route(), (route) => false)
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CurrentUserProfileView extends StatefulWidget {
  final String fullname;
  final String homeCountry;
  final String studyAbroadDestination;
  final int followers;
  final int following;

  const CurrentUserProfileView({
    super.key,
    required this.fullname,
    required this.homeCountry,
    required this.studyAbroadDestination,
    required this.followers,
    required this.following,
  });

  @override
  State<CurrentUserProfileView> createState() => _CurrentUserProfileViewState();
}

class _CurrentUserProfileViewState extends State<CurrentUserProfileView> {
  final TextEditingController _updateNameController = TextEditingController();

  @override
  void dispose() {
    _updateNameController.dispose();
    super.dispose();
  }

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
                  Consumer(builder: (context, ref, _) {
                    final user = ref.watch(userCountStreamProvider(
                        FirebaseAuth.instance.currentUser!.uid));

                    return user.when(
                      data: (data) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const FollowersFollowingWidget(
                              count: 0,
                              title: "Posts",
                            ),
                            const SizedBox(width: 10),
                            FollowersFollowingWidget(
                              count: data.followers.length,
                              title: "Followers",
                            ),
                            const SizedBox(width: 10),
                            FollowersFollowingWidget(
                              count: data.following.length,
                              title: "Following",
                            ),
                          ],
                        );
                      },
                      error: (error, stackTrace) {
                        return Text(error.toString());
                      },
                      loading: () => const CircularProgressIndicator(),
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CustomButton1(
                        text: "Explore",
                        onTap: () {
                          Navigator.push(context, ExplorePeopleView.route());
                        },
                      ),
                      SizedBox(width: 5),
                      CustomButton1(
                          text: "Edit Profile",
                          onTap: () {
                            Navigator.push(context, EditProfileView.route());
                          }),
                    ],
                  )
                ],
              ),
              const Spacer()
            ],
          ),
          Consumer(builder: (context, ref, _) {
            final user = ref.watch(userNotifierProvider);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user!.fullname.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade200,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // const SizedBox(width: 10),
                // GestureDetector(
                //   onTap: () {
                //     showDialog(
                //         context: context,
                //         builder: (context) {
                //           _updateNameController.text = user.fullname.toString();
                //           return AlertDialog(
                //             title: const Text("Edit Name"),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             content: TextField(
                //               controller: _updateNameController,
                //               decoration: const InputDecoration(
                //                 hintText: "Enter your name",
                //               ),
                //             ),
                //             actions: [
                //               TextButton(
                //                 onPressed: () {
                //                   Navigator.pop(context);
                //                 },
                //                 child: const Text("Cancel"),
                //               ),
                //               TextButton(
                //                 onPressed: () async {
                //                   await ref
                //                       .read(userNotifierProvider.notifier)
                //                       .updateUserName(
                //                           _updateNameController.text)
                //                       .then((value) {
                //                     if (value != null) {
                //                       Navigator.pop(context);
                //                     } else {
                //                       showSnackBar(context,
                //                           message: "Something went wrong");
                //                     }
                //                   });
                //                 },
                //                 child: const Text("Save"),
                //               ),
                //             ],
                //           );
                //         });
                //   },
                //   child: const Icon(
                //     Icons.edit,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            );
          }),
          const SizedBox(height: 5),
          Text("Home Country: ${widget.homeCountry}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade200,
                fontWeight: FontWeight.w400,
              )),
          Text("Study Abroad Destination: ${widget.studyAbroadDestination}",
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

class FollowersFollowingWidget extends StatelessWidget {
  final int count;
  final String title;
  const FollowersFollowingWidget({
    super.key,
    required this.count,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 15,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
