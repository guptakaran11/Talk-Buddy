// ignore_for_file: file_names, prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkbuddy/Model/chatMessageModel.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messagesCollection = "messages";

class DatabaseServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseServices(); // i changed this line from DatabaseServices(){} to DatabaseServices();

  Future<void> createUser(
      String uid, String email, String name, String imageUrl) async {
    try {
      await db.collection(userCollection).doc(uid).set(
        {
          "email": email,
          "image": imageUrl,
          "last_active": DateTime.now().toUtc(),
          "name": name,
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return db.collection(userCollection).doc(uid).get();
  }

  Future<QuerySnapshot> getUserFromDatabase({String? name}) {
    Query query = db.collection(userCollection);
    if (name != null) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return query.get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return db
        .collection(chatCollection)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return db
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatID) {
    return db
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessageModel message) async {
    try {
      await db
          .collection(chatCollection)
          .doc(chatID)
          .collection(messagesCollection)
          .add(message.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateChatData(String chatID, Map<String, dynamic> data) async {
    try {
      await db.collection(chatCollection).doc(chatID).update(data);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateUserLastSeenTime(String uid) async {
    try {
      await db.collection(userCollection).doc(uid).update(
        {
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteChat(String chatID) async {
    try {
      await db.collection(chatCollection).doc(chatID).delete();
    } catch (e) {
      log(e.toString());
    }
  }
}
