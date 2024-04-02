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
  }

  @override
  void dispose() {
    super.dispose();
  }
}
