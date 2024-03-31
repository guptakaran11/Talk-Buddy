// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/provider/messagePageProvider.dart';
import 'package:talkbuddy/Model/chatMessageModel.dart';
import 'package:talkbuddy/Model/chatModel.dart';
import 'package:talkbuddy/View/widgets/customListViewTiles.dart';
import 'package:talkbuddy/View/widgets/inputFields.dart';
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
            widget.chat.uid,
            auth,
            messagesListViewController,
          ),
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
                      onPressed: () {
                        pageProvider.deleteChat();
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                    secondartAction: IconButton(
                      onPressed: () {
                        pageProvider.goBack();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  messagesListView(),
                  sendMessageForm(),
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
          height: height * 0.72,
          child: ListView.builder(
            controller: messagesListViewController,
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
                    .firstWhere((m) => m.uid == message.senderID),
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

  Widget sendMessageForm() {
    return Container(
      height: height * 0.07,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.03,
      ),
      child: Form(
        key: messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageMessageButton(),
            SizedBox(
              width: width * 0.64,
              child: CustomTextFormField(
                onSaved: (value) {
                  pageProvider.message = value;
                },
                regExp: r"^(?!\s*$).+",
                hintText: "Type a message",
                obscureText: false,
              ),
            ),
            sendMessageButton(),
            // i changed this position so run it
          ],
        ),
      ),
    );
  }

  Widget sendMessageButton() {
    double size = height * 0.05;
    return SizedBox(
      height: size,
      width: size,
      child: IconButton(
        onPressed: () {
          if (messageFormState.currentState!.validate()) {
            messageFormState.currentState!.save();
            pageProvider.sendTextMessage();
            messageFormState.currentState!.reset();
          }
        },
        icon: const Icon(
          Icons.send_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget imageMessageButton() {
    double size = height * 0.04;
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        onPressed: () {
          pageProvider.sendImageMessage();
        },
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1.0),
        child: const Icon(
          Icons.camera_enhance,
        ),
      ),
    );
  }
}
