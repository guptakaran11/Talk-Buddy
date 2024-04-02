// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/provider/chatsPageProvider.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';
import 'package:talkbuddy/Model/chatMessageModel.dart';
import 'package:talkbuddy/Model/chatModel.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';
import 'package:talkbuddy/View/pages/chatAndUserPages/messageScreen.dart';
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
  late NavigationServices navigation;
  late ChatsPageProvider pageProvider;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationServices>();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        pageProvider = context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.04,
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
      },
    );
  }

  Widget chatsList() {
    List<ChatModel>? chats = pageProvider.chats;
    return Expanded(
      child: (() {
        if (chats != null) {
          if (chats.isNotEmpty) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                return chatTile(
                  chats[index],
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Chats Found. ",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget chatTile(ChatModel chat) {
    List<ChatUserModel> recepients = chat.recepient();
    bool isActive = recepients.any((doc) => doc.wasRecentlyActive());
    String subTitleText = "";
    if (chat.messages.isNotEmpty) {
      subTitleText = chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: height * 0.10,
      title: chat.title(),
      subtitle: subTitleText,
      imagePath: chat.imageURL(),
      isActive: isActive,
      isActivity: chat.activity,
      onTap: () {
        navigation.navigateToPage(
          MessageScreen(
            chat: chat,
          ),
        );
      },
    );
  }
}
