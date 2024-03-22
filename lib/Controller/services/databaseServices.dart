// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messageCollection = "Messages";

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
}
