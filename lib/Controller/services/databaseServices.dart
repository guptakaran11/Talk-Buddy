// ignore_for_file: file_names, prefer_interpolation_to_compose_strings

import 'dart:developer';

//* Packages
import 'package:cloud_firestore/cloud_firestore.dart';

//* Models
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

  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      DocumentReference chat = await db.collection(chatCollection).add(data);
      return chat;
    } catch (e) {
      log("Error in creating Chat");
      log(e.toString());
    }
    return null; 
  }

  Future<QuerySnapshot> getFriends(String userId) async {
    // Fetch friends from the 'friends' collection
    return FirebaseFirestore.instance
        .collection('friends')
        .where('userIds', arrayContains: userId)
        .get();
  }

  // Method to add a friend in the database
  Future<void> addFriend(String userId, String friendId) async {
    // Add a new document to the 'friends' collection
    await FirebaseFirestore.instance.collection('friends').add({
      'userIds': [userId, friendId],
      // Other friend details if necessary
    });
  }

  // Method to remove a friend from the database
  Future<void> removeFriend(String userId, String friendId) async {
    // Find the document representing the friendship and delete it
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('friends')
        .where('userIds', arrayContains: userId)
        .where('userIds', arrayContains: friendId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
