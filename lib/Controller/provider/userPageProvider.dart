// ignore_for_file: file_names, unnecessary_overrides

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider auth;

  late DatabaseServices database;
  late NavigationServices navigation;

  List<ChatUserModel>? users;
  late List<ChatUserModel> selectedUsers;

  List<ChatUserModel> get selectedUser {
    return selectedUsers;
  }

  UsersPageProvider(this.auth) {
    selectedUsers = [];
    database = GetIt.instance.get<DatabaseServices>();
    navigation = GetIt.instance.get<NavigationServices>();
    getUserFromDatabase();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUserFromDatabase({String? name}) async {
    selectedUsers = [];
    try {
      database.getUserFromDatabase(name: name).then(
        (snapshot) {
          users = snapshot.docs.map(
            (doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data["uid"] = doc.id;
              return ChatUserModel.fromJSON(data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {
      log("Error getting users.");
      log(e.toString());
    }
  }
}
