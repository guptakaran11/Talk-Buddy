// ignore_for_file: file_names, recursive_getters

import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/services/cloudStorageServices.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/mediaServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';
import 'package:talkbuddy/Model/chatMessageModel.dart';

class MessagePageProvider extends ChangeNotifier {
  late DatabaseServices db;
  late CloudStorageService storage;
  late MediaServices media;
  late NavigationServices navigation;

  AuthenticationProvider auth;
  ScrollController messagesListViewController;

  String chatId;
  List<ChatMessageModel>? messageModel;

  late StreamSubscription messagesStream;

  String? message;

  String get messages {
    return messages;
  }

  set messages(String value) {
    message = value;
  }

  MessagePageProvider(this.chatId, this.auth, this.messagesListViewController) {
    db = GetIt.instance.get<DatabaseServices>();
    storage = GetIt.instance.get<CloudStorageService>();
    media = GetIt.instance.get<MediaServices>();
    navigation = GetIt.instance.get<NavigationServices>();
    listenToMessages();
  }

  @override
  void dispose() {
    messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      messagesStream = db.streamMessagesForChat(chatId).listen(
        (snapshot) {
          List<ChatMessageModel> messages = snapshot.docs.map(
            (msg) {
              Map<String, dynamic> messageData =
                  msg.data() as Map<String, dynamic>;
              return ChatMessageModel.fromJSON(messageData);
            },
          ).toList();
          messageModel = messages;
          notifyListeners();
        },
      );
    } catch (e) {
      log("Error getting messages. ");
      log(e.toString());
    }
  }

  void sendTextMessage() {
    if (message != null) {
      ChatMessageModel messageToSend = ChatMessageModel(
        senderID: auth.userModel.uid,
        type: MessageType.TEXT,
        content: message!,
        sentTime: DateTime.now(),
      );
      db.addMessageToChat(chatId, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await storage.saveChatImageToStorage(
            chatId, auth.userModel.uid, file);

        ChatMessageModel messageToSend = ChatMessageModel(
          senderID: auth.userModel.uid,
          type: MessageType.IMAGE,
          content: downloadURL!,
          sentTime: DateTime.now(),
        );
        db.addMessageToChat(chatId, messageToSend);
      }
    } catch (e) {
      log("Error sending image message. ");
      log(e.toString());
    }
  }

  void deleteChat() {
    goBack();
    db.deleteChat(chatId);
  }

  void goBack() {
    navigation.goBackToPage();
  }
}
