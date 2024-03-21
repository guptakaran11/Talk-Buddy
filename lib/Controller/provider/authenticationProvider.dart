import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth auth;
  late final NavigationServices navigationServices;
  late final DatabaseServices databaseServices;

  AuthenticationProvider() {
    auth = FirebaseAuth.instance;
    navigationServices = GetIt.instance.get<NavigationServices>();
    databaseServices = GetIt.instance.get<DatabaseServices>();

    auth.authStateChanges().listen((user) {
      if (user != null) {
        log("Logged In");
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
