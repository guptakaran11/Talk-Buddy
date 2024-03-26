import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:talkbuddy/Controller/provider/authenticationProvider.dart';
import 'package:talkbuddy/Controller/services/cloudStorageServices.dart';
import 'package:talkbuddy/Controller/services/databaseServices.dart';
import 'package:talkbuddy/Controller/services/mediaServices.dart';
import 'package:talkbuddy/Controller/services/navigationService.dart';
import 'package:talkbuddy/View/widgets/inputFields.dart';
import 'package:talkbuddy/View/widgets/roundedButton.dart';
import 'package:talkbuddy/View/widgets/roundedImage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late double height;
  late double width;

  late AuthenticationProvider auth;
  late DatabaseServices db;
  late CloudStorageService cloudStorage;
  late NavigationServices navigation;

  String? email;
  String? password;
  String? name;

  PlatformFile? profileImage;

  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthenticationProvider>(context);
    db = GetIt.instance.get<DatabaseServices>();
    cloudStorage = GetIt.instance.get<CloudStorageService>();
    navigation = GetIt.instance.get<NavigationServices>();

    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImageField(),
            SizedBox(
              height: height * 0.06,
            ),
            SizedBox(
              height: height * 0.32,
              child: Form(
                key: registerFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      onSaved: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      regExp: r".{8,}",
                      hintText: "Name",
                      obscureText: false,
                    ),
                    CustomTextFormField(
                      onSaved: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      regExp:
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      hintText: "Email",
                      obscureText: false,
                    ),
                    CustomTextFormField(
                      onSaved: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      regExp: r".{8,}",
                      hintText: "Password",
                      obscureText: false,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            RoundedButton(
              name: "Register",
              height: height * 0.065,
              width: width * 0.65,
              onPressed: () async {
                if (registerFormKey.currentState!.validate() &&
                    profileImage != null) {
                  registerFormKey.currentState!.save();
                  String? uid = await auth.registerUserWithEmailAndPassword(
                      email!, password!);
                  String? imageUrl = await cloudStorage.saveUserImageToStorage(
                      uid!, profileImage!);
                  await db.createUser(uid, email!, name!, imageUrl!);
                  await auth.logOut();
                  await auth.loginWithEmailAndPassword(email!, password!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaServices>().pickImageFromLibrary().then(
          (file) {
            setState(() {
              profileImage = file;
              log(profileImage.toString());
            });
          },
        );
      },
      child: () {
        if (profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: profileImage!,
            size: height * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath: "https://i.pravatar.cc/1000?img=65",
            size: height * 0.15,
          );
        }
      }(),
    );
  }
}
