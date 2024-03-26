// ignore_for_file: file_names, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  TEXT,
  IMAGE,
  UNKNOWN,
}

class ChatMessageModel {
  final String senderID;
  final MessageType type;
  final String content;
  final DateTime sentTime;

  ChatMessageModel({
    required this.senderID,
    required this.type,
    required this.content,
    required this.sentTime,
  });

  factory ChatMessageModel.fromJSON(Map<String, dynamic> json) {
    MessageType messageType;
    switch (json["type"]) {
      case "text":
        messageType = MessageType.TEXT;
        break;
      case "image":
        messageType = MessageType.IMAGE;
        break;
      default:
        messageType = MessageType.UNKNOWN;
    }
    return ChatMessageModel(
      senderID: json["sender_id"],
      type: messageType,
      content: json["content"],
      sentTime: json["sent_time"].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    String messageType;
    switch (type) {
      case MessageType.TEXT:
        messageType = "text";
        break;
      case MessageType.IMAGE:
        messageType = "image";
        break;
      default:
        messageType = "";
    }
    return {
      "sender_id": senderID,
      "type": messageType,
      "content": content,
      "sent_time": Timestamp.fromDate(sentTime),
    };
  }
}
