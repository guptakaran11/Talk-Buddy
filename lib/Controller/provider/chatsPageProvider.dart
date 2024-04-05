// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

//* Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//* Providers
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';

//* Services
import 'package:talkbuddy/Controller/services/databaseServices.dart';

//* Models
import 'package:talkbuddy/Model/chatMessageModel.dart';
import 'package:talkbuddy/Model/chatModel.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseServices db;

  List<ChatModel>? chats;

  late StreamSubscription chatsStream;

  ChatsPageProvider(this.auth) {
    db = GetIt.instance.get<DatabaseServices>();
    getChats();
  }

  @override
  void dispose() {
    chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      chatsStream =
          db.getChatsForUser(auth.userModel.uid).listen((snapshot) async {
        chats = await Future.wait(
          snapshot.docs.map(
            (doc) async {
              Map<String, dynamic> chatData =
                  doc.data() as Map<String, dynamic>;

              //* Get Users to ChatScreen
              List<ChatUserModel> members = [];
              for (var uid in chatData["members"]) {
                DocumentSnapshot userSnapshot = await db.getUser(uid);
                Map<String, dynamic> userData =
                    userSnapshot.data() as Map<String, dynamic>;
                userData["uid"] = userSnapshot.id;
                members.add(
                  ChatUserModel.fromJSON(userData),
                );
              }

              //* Get Last Message from the Chat
              List<ChatMessageModel> messages = [];
              QuerySnapshot chatMessage =
                  await db.getLastMessageForChat(doc.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                    chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessageModel message =
                    ChatMessageModel.fromJSON(messageData);
                messages.add(message);
              }

              //* Return chats Instances
              return ChatModel(
                uid: doc.id,
                currentUserUid: auth.userModel.uid,
                members: members,
                messages: messages,
                activity: chatData["is_activity"],
                group: chatData["is_group"],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      log('Error getting chats from the database.');
      log(e.toString());
    }
  }
}
