// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/provider/messagePageProvider.dart';
import 'package:talkbuddy/Model/chatMessageModel.dart';
import 'package:talkbuddy/Model/chatModel.dart';
import 'package:talkbuddy/View/widgets/customListViewTiles.dart';
import 'package:talkbuddy/View/widgets/topBar.dart';

class MessageScreen extends StatefulWidget {
  final ChatModel chat;
  const MessageScreen({super.key, required this.chat});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late double height;
  late double width;

  late AuthenticationProvider auth;
  late MessagePageProvider pageProvider;

  late GlobalKey<FormState> messageFormState;
  late ScrollController messagesListViewController;

  @override
  void initState() {
    super.initState();
    messageFormState = GlobalKey<FormState>();
    messagesListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MessagePageProvider>(
          create: (_) => MessagePageProvider(
              widget.chat.uid, auth, messagesListViewController),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        pageProvider = context.watch<MessagePageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.02,
              ),
              height: height,
              width: width * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    widget.chat.title(),
                    fontSize: 18,
                    primaryAction: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                    secondartAction: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  messagesListView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget messagesListView() {
    if (pageProvider.messageModel != null) {
      if (pageProvider.messageModel!.isNotEmpty) {
        return SizedBox(
          height: height * 0.74,
          child: ListView.builder(
            itemCount: pageProvider.messageModel!.length,
            itemBuilder: (BuildContext context, int index) {
              ChatMessageModel message = pageProvider.messageModel![index];
              bool isOwnMessage = message.senderID == auth.userModel.uid;
              return CustomMessageListViewTile(
                height: height,
                tileWidth: width * 0.80,
                message: message,
                isOwnMessage: isOwnMessage,
                sender: widget.chat.members
                    .where((m) => m.uid == message.senderID)
                    .first,
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the first to say Hi!",
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
  }
}
