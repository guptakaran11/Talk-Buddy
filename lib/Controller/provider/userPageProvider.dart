// ignore_for_file: file_names, unnecessary_overrides

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';
import 'package:talkbuddy/Model/chatModel.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';
import 'package:talkbuddy/View/pages/chatAndUserPages/messageScreen.dart';

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

  void updateSelectedUsers(ChatUserModel user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      //  Creating ChatGroup
      List<String> membersIds = selectedUsers.map((user) => user.uid).toList();
      membersIds.add(auth.userModel.uid);
      bool isGroup = selectedUsers.length > 1;
      DocumentReference? doc = await database.createChat(
        {
          "is_group": isGroup,
          "is_activity": false,
          "members": membersIds,
        },
      );
      // Navigate to Chat Group page
      List<ChatUserModel> members = [];
      for (var uid in membersIds) {
        DocumentSnapshot userSnapshot = await database.getUser(uid);
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        userData["uid"] = userSnapshot.id;
        members.add(
          ChatUserModel.fromJSON(userData),
        );
      }
      MessageScreen messageScreen = MessageScreen(
        chat: ChatModel(
          uid: doc!.id,
          currentUserUid: auth.userModel.uid,
          members: members,
          messages: [],
          activity: false,
          group: isGroup,
        ),
      );
      selectedUsers = [];
      notifyListeners();
      navigation.navigateToPage(messageScreen);
    } catch (e) {
      log("Error creating chat.");
      log(e.toString());
    }
  }
}
