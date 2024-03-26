
// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';

// Services
import 'package:talkbuddy/Controller/services/navigationService.dart';

// Pages
import 'package:talkbuddy/View/pages/homePage.dart';
import 'package:talkbuddy/View/pages/authenticationPages/loginPage.dart';
import 'package:talkbuddy/View/pages/authenticationPages/registrationPage.dart';
import 'package:talkbuddy/View/pages/splashPage.dart';

void main() async {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Talk Buddy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          ),
          scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationServices.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => const RegistrationPage(),
          '/home': (BuildContext context) => const HomePage(),
        },
      ),
    );
  }
}
