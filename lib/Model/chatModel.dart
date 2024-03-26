// ignore_for_file: file_names

import 'package:talkbuddy/Model/chatUserModel.dart';
import 'package:talkbuddy/Model/chatMessageModel.dart';

class ChatModel {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUserModel> members;
  List<ChatMessageModel> messages;

  late final List<ChatUserModel> recepients;

  ChatModel({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    recepients = members.where((i) => i.uid != currentUserUid).toList();
  }

  List<ChatUserModel> recepient() {
    return recepients;
  }

  String title() {
    return !group
        ? recepients.first.name
        : recepients.map((user) => user.name).join(", "); // I have to make it to gave a group name who created the group in future.
  }

  String imageURL() {
    return !group
        ? recepients.first.imageURl
        : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }
}
