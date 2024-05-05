// ignore_for_file: file_names, unnecessary_overrides

import 'dart:developer';

//* Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//* Providers
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';

//* Services
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';

//* Models
import 'package:talkbuddy/Model/chatModel.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';

//* Pages
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

  List<ChatUserModel>? friends = []; // Initialize with an empty list
  bool isLoading = true;

  UsersPageProvider(this.auth) {
    selectedUsers = [];
    database = GetIt.instance.get<DatabaseServices>();
    navigation = GetIt.instance.get<NavigationServices>();
    getUserFromDatabase();
    getFriends();
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

  // Method to fetch the current user's friends from the database
  void getFriends() async {
    try {
      // Assuming you have a 'friends' collection in Firestore
      // where each document represents a friendship
      QuerySnapshot friendsSnapshot =
          await database.getFriends(auth.userModel.uid);
      friends = friendsSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ChatUserModel.fromJSON(data);
      }).toList();
      notifyListeners();
    } catch (e) {
      log("Error getting friends: $e");
    }
  }

  // Method to add a friend
  void addFriend(ChatUserModel user) async {
    try {
      // Add friend to the database
      await database.addFriend(auth.userModel.uid, user.uid);
      getFriends(); // Refresh the friends list
    } catch (e) {
      log("Error adding friend: $e");
    }
  }

  // Method to remove a friend
  void removeFriend(ChatUserModel user) async {
    try {
      // Remove friend from the database
      await database.removeFriend(auth.userModel.uid, user.uid);
      getFriends(); // Refresh the friends list
    } catch (e) {
      log("Error removing friend: $e");
    }
  }
}
