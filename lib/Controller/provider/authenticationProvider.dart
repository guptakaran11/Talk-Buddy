import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';
import 'package:talkbuddy/Model/chatUserModel.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationServices navigationServices;
  late final DatabaseServices databaseServices;

  late ChatUserModel userModel;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigationServices = GetIt.instance.get<NavigationServices>();
    databaseServices = GetIt.instance.get<DatabaseServices>();

    auth.authStateChanges().listen((user) {
      if (user != null) {
        log("Logged In");
        databaseServices.updateUserLastSeenTime(user.uid);
        databaseServices.getUser(user.uid).then(
          (snapshot) {
            Map<String, dynamic> userData =
                snapshot.data()! as Map<String, dynamic>;
            userModel = ChatUserModel.fromJSON(
              {
                "uid": user.uid,
                "name": userData["name"],
                "email": userData["email"],
                "last_active": userData["last_active"],
                "image": userData["image"],
              },
            );
            log(userModel.toString());
            log(userModel.toMap().toString());
          },
        );
      } else {
        log("Not Authenticated");
      }
    });
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(auth.currentUser.toString());
    } on FirebaseAuthException {
      log("Error logging user into Firebase");
    } catch (e) {
      log(e.toString());
    }
  }
}