// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:talkbuddy/View/pages/chatAndUserPages/chatsScreen.dart';
import 'package:talkbuddy/View/pages/chatAndUserPages/userScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> pages = [
    const ChatsPage(),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(
              Icons.chat_bubble_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: "Users",
            icon: Icon(
              Icons.supervisor_account_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
