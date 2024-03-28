// ignore_for_file: file_names, recursive_getters

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

  String? message;

  String get messages {
    return messages;
  }

  MessagePageProvider(this.chatId, this.auth, this.messagesListViewController) {
    db = GetIt.instance.get<DatabaseServices>();
    storage = GetIt.instance.get<CloudStorageService>();
    media = GetIt.instance.get<MediaServices>();
    navigation = GetIt.instance.get<NavigationServices>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    navigation.goBackToPage();
  }
}
