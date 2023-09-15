// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/views/app/main_views/views/home/random_fact.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../notifiers/refresh_notifier/refresh_notifier.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    ref.watch(refreshNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AbroadLink"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, RandomFactView.route());
            },
            icon: const Icon(Icons.lightbulb),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Community",
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
                    icon: const Icon(Icons.filter_alt, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          TextPost(),
          TextAndImagePost(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

class TextAndImagePost extends StatelessWidget {
  const TextAndImagePost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ConstColors.boxBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bartu Can SEZGİN",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "2 hours ago",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae n Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae n",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                //image list
                SizedBox(
                  height: 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ImagePostContainer(
                        imageURL:
                            "https://www.nerdwallet.com/assets/blog/wp-content/uploads/2021/04/GettyImages-172672886-1920x1080.jpg",
                      ),
                      ImagePostContainer(
                        imageURL:
                            "https://www.shutterstock.com/shutterstock/photos/758602234/display_1500/stock-photo-empty-airport-terminal-lounge-with-airplane-on-background-d-illustration-758602234.jpg",
                      ),
                      ImagePostContainer(
                        imageURL:
                            "https://www.nerdwallet.com/assets/blog/wp-content/uploads/2021/04/GettyImages-172672886-1920x1080.jpg",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, left: 3, right: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_border, color: Colors.white),
                        Text(
                          "  2.1k",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Icon(Icons.comment_outlined, color: Colors.white),
                        Text(
                          "  2.1k",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.bookmark_outline, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePostContainer extends StatelessWidget {
  const ImagePostContainer({
    super.key,
    required this.imageURL,
  });

  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 5, left: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.network(
          imageURL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TextPost extends StatelessWidget {
  const TextPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ConstColors.boxBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bartu Can SEZGİN",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "2 hours ago",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae n",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, left: 3, right: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.favorite_border, color: Colors.white),
                        Text(
                          "  2.1k",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Icon(Icons.comment_outlined, color: Colors.white),
                        Text(
                          "  2.1k",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.bookmark_outline, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
