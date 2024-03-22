// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String userCollection = "Users";

class CloudStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  CloudStorageService(); // i have changed this from CloudStorageServices(){} to CloudStorageServices();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref =
          storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(
          file.path.toString(),
        ),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      log(e.toString());
    }
    return null; // i add this line in case it does not gave anything
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String userID, PlatformFile file) async {
    try {
      Reference ref = storage.ref().child(
          'images/chats/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(
        File(
          file.path.toString(),
        ),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      log(e.toString());
    }
    return null; // i added this line in case there is nothing to return
  }
}
