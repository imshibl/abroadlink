// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abroadlink/const/colors.dart';
import 'package:abroadlink/views/app/main_views/views/explore/explore_people.view.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, ExplorePeopleView.route());
              },
              icon: Icon(Icons.person_add),
            ),
          ],
        ),
        body: ListView(
          children: [
            ChatContainer(),
          ],
        ));
  }
}

class ChatContainer extends StatelessWidget {
  const ChatContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade700,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
              ),
              Positioned(
                bottom: 3,
                right: 2,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(
                      color: ConstColors.mainBgColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Malfred",
                style: TextStyle(
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(
                width: 150,
                child: Text(
                  "Last Message fdfdfdfdfdfdfdfdfdfdfdfdf",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "12:00 PM",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10),
              CountryFlag.fromCountryCode(
                'US',
                height: 25,
                width: 25,
                borderRadius: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
