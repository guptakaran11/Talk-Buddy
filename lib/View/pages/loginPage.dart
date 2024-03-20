// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:talkbuddy/View/widgets/inputFields.dart';
import 'package:talkbuddy/View/widgets/roundedButton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double height;
  late double width;

  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.02,
            ),
            height: height * 0.99,
            width: width * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.10,
                  child: const Text(
                    'Talk Buddy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                SizedBox(
                  height: height * 0.36,
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextFormField(
                          onSaved: (value) {},
                          regExp:
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          hintText: 'Email',
                          obscureText: false,
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        CustomTextFormField(
                          onSaved: (value) {},
                          regExp: r".{8,}",
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        RoundedButton(
                          name: 'Login',
                          height: height * 0.065,
                          width: width * 0.65,
                          onPressed: () {},
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
