// ignore_for_file: file_names

import 'package:firebase_storage/firebase_storage.dart';

const String userCollection = "Users";

class CloudStorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;
  CloudStorageService(); // i have changed this from CloudStorageServices(){} to CloudStorageServices();
}
