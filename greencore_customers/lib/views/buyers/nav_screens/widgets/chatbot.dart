import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/nav_screens/home_screen.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  void initState() {
    super.initState();
    _initChat();
  }

  _initChat() async {
    WidgetsFlutterBinding.ensureInitialized();
    await KommunicateFlutterPlugin.buildConversation({
      'appId': '310455bba239a00856b03f88a8def31e',
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Handle back button press
          //Navigator.pop(context);
          // Navigate back to the home screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
          return false;
          //return true; // Allow pop
        },
        child: Container());
  }
}
