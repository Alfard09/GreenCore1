import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Color.fromARGB(0, 119, 240, 6)));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 6, 153, 19)),
          useMaterial3: true,
          fontFamily: 'Pop-Regular'),
      home: const MainScreen(),
    );
  }
}
