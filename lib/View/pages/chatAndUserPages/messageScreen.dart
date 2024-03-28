// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Model/chatModel.dart';
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

  late GlobalKey<FormState> messageFormState;
  late ScrollController messagesListViewController;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
                fontSize: 15,
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
            ],
          ),
        ),
      ),
    );
  }
}
