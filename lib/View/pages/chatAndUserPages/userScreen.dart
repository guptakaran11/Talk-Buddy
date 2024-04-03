// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/provider/userPageProvider.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';
import 'package:talkbuddy/View/widgets/customListViewTiles.dart';
import 'package:talkbuddy/View/widgets/inputFields.dart';
import 'package:talkbuddy/View/widgets/topBar.dart';

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
                    auth.logOut();
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              CustomTextField(
                onEditingComplete: (value) {},
                hintText: "Search.... ",
                obscureText: false,
                controller: searchFieldTextEditingController,
                icon: Icons.search_rounded,
              ),
              usersList(),
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
}
