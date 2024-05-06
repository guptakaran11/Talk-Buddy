// ignore_for_file: file_names

//* Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//* Providers
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/provider/userPageProvider.dart';

//* Models
import 'package:talkbuddy/Model/chatUserModel.dart';

//* Widgets
import 'package:talkbuddy/View/widgets/customListViewTiles.dart';
import 'package:talkbuddy/View/widgets/inputFields.dart';
import 'package:talkbuddy/View/widgets/roundedButton.dart';
import 'package:talkbuddy/View/widgets/topBar.dart';

//* Utilities
import '../Utilities/utility.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late double height;
  late double width;

  late AuthenticationProvider auth;
  late UsersPageProvider pageProvider;

  final TextEditingController searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        pageProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          height: height * 0.98,
          width: width * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                primaryAction: IconButton(
                  onPressed: () {
                    showAnimatedDialog(
                      context: context,
                      title: "LogOut",
                      content:
                          "Are you sure you want to Logout from the Talk-Buddy?",
                      actionText: "LogOut",
                      onActionPressed: (value) {
                        if (value) {
                          // Logout  the chat
                          auth.logOut();
                        }
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              CustomTextField(
                onEditingComplete: (value) {
                  pageProvider.getUserFromDatabase(name: value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search.... ",
                obscureText: false,
                controller: searchFieldTextEditingController,
                icon: Icons.search_rounded,
              ),
              usersList(),
              createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget usersList() {
    List<ChatUserModel>? users = pageProvider.users;
    return Expanded(child: () {
      if (users != null) {
        if (users.isNotEmpty) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomListViewTile(
                height: height * 0.10,
                title: users[index].name,
                subtitle: "Last Active: ${users[index].lastDayActive()} ",
                imagePath: users[index].imageURl,
                isActive: users[index].wasRecentlyActive(),
                isSelected: pageProvider.selectedUsers.contains(
                  users[index],
                ),
                onTap: () {
                  pageProvider.updateSelectedUsers(
                    users[index],
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Users found!!",
              style: TextStyle(
                color: Colors.white,
              ),
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
    }());
  }

  Widget createChatButton() {
    return Visibility(
      visible: pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: pageProvider.selectedUsers.length == 1
            ? "Chat With ${pageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: height * 0.08,
        width: width * 0.80,
        onPressed: () {
          showAnimatedDialog(
            context: context,
            title: pageProvider.selectedUsers.length == 1
                ? "Chat With ${pageProvider.selectedUsers.first.name}"
                : "Create Group Chat",
            content: pageProvider.selectedUsers.length == 1
                ? " Are you sure you want to Chat With ${pageProvider.selectedUsers.first.name}"
                : " Are you sure you want to Create Group Chat",
            actionText: 'Chat',
            onActionPressed: (value) {
              if (value) {
                pageProvider.createChat();
              }
            },
          );
        },
      ),
    );
  }

  Widget friendsList() {
    List<ChatUserModel>? friends = pageProvider.friends;
    return Expanded(child: () {
      if (friends != null) {
        if (friends.isNotEmpty) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: friends.length,
            itemBuilder: (BuildContext context, int index) {
              bool isSelected =
                  pageProvider.selectedUsers.contains(friends[index]);
              return CustomListViewTile(
                height: height * 0.10,
                title: friends[index].name,
                subtitle: "Last Active: ${friends[index].lastDayActive()} ",
                imagePath: friends[index].imageURl,
                isActive: friends[index].wasRecentlyActive(),
                isSelected: isSelected,
                onTap: () {
                  pageProvider.updateSelectedUsers(friends[index]);
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "No Friends found!!",
              style: TextStyle(
                color: Colors.white,
              ),
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
    }());
  }

  Widget addFriendButton() {
    return Visibility(
      visible: pageProvider.selectedUser.isNotEmpty,
      child: RoundedButton(
        name: "Add Friend",
        height: height * 0.08,
        width: width * 0.80,
        onPressed: () {
          pageProvider.addFriend(pageProvider.selectedUser.first);
        },
      ),
    );
  }
}
