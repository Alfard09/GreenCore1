import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore1_admin_panel/views/screens/main_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:greencore1_admin_panel/views/screens/trial/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyD0Jn2sJy9kSTkZWsxByoFOtQVzsHoot7A",
              appId: "1:935977688778:web:e679d8d7523a73ce7e5e33",
              messagingSenderId: "G-F0EDL38MQQ",
              projectId: "greencore1-274ac",
              storageBucket: "greencore1-274ac.appspot.com",
            )
          : null);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  // Future getUserInfo() async {
  //   await getUser();
  //   setState(() {
  //     print(uid);
  //   });
  // }

  // @override
  // void initState() {
  //
  //   getUserInfo();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}


//    flutter run -d chrome --web-renderer html
