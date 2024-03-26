// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/View/widgets/customListViewTiles.dart';
import 'package:talkbuddy/View/widgets/topBar.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double height;
  late double width;

  late AuthenticationProvider auth;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      height: height * 0.98,
      width: width * 0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBar(
            'Chats',
            primaryAction: IconButton(
              onPressed: () {
                auth.logOut();
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Color.fromRGBO(0, 82, 218, 1.0),
              ),
            ),
          ),
          chatsList(),
        ],
      ),
    );
  }

  Widget chatsList() {
    return Expanded(
      child: chatTile(),
    );
  }

  Widget chatTile() {
    return CustomListViewTileWithActivity(
      height: height * 0.10,
      title: "Ram Chandra",
      subtitle: "Hello!",
      imagePath: "https://i.pravatar.cc/300",
      isActive: false,
      isActivity: false,
      onTap: () {},
    );
  }
}
