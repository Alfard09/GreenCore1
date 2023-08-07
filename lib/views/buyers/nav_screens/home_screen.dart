import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/search_input_wdget.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/welcome_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 25, right: 15),
      child: Column(
        children: [
          Welcome(),
          SizedBox(
            height: 10,
          ),
          SearchInputWidget()
        ],
      ),
    );
  }
}
