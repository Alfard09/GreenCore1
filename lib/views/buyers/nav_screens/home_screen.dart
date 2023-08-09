import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/search_input_wdget.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/welcome_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Welcome(),
        SizedBox(
          height: 10,
        ),
        SearchInputWidget(),
        BannerWidget(),
      ],
    );
  }
}
