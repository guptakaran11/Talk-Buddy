// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Model/chatModel.dart';

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

  void getChats() async {}
}
