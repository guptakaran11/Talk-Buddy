// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messageCollection = "Messages";

class DatabaseServices {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  DatabaseServices(); // i changed this line from DatabaseServices(){} to DatabaseServices();
}
