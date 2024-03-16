// ignore_for_file: file_names

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkbuddy/Controller/services/cloudStorageServices.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/mediaServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({super.key, required this.onInitializationComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    setUp().then(
      (_) => widget.onInitializationComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Talk Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
      ),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 400,
            width: 400,
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(
                'assets/images/chatImage.png',
              ),
            )),
          ),
        ),
      ),
    );
  }

  Future<void> setUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    registerServices();
  }

  void registerServices() {
    GetIt.instance.registerSingleton<NavigationServices>(
      NavigationServices(),
    );
    GetIt.instance.registerSingleton<MediaServices>(
      MediaServices(),
    );
    GetIt.instance.registerSingleton<CloudStorageService>(
      CloudStorageService(),
    );
    GetIt.instance.registerSingleton<DatabaseServices>(
      DatabaseServices(),
    );
  }
}
