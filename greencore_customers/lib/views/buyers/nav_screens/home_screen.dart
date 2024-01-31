import 'dart:math';

import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/search_input_wdget.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/welcome_widget.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Welcome(),
            SizedBox(
              height: 10,
            ),
            // SearchInputWidget(),
            BannerWidget(),
            CategoryText(),
            SizedBox(
              height: 5,
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FloatingActionButton(
          shape: CircleBorder(eccentricity: sqrt1_2),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade400,
          onPressed: () async {
            print('working');
            WidgetsFlutterBinding.ensureInitialized();
            await KommunicateFlutterPlugin.buildConversation({
              'appId': '310455bba239a00856b03f88a8def31e',
            });
            KommunicateFlutterPlugin.openConversations();
            // Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen()), // Replace PreviousScreen with your actual screen
            );
          },
          child: Icon(
            Icons.chat,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/banner_widget.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/category_text.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/search_input_wdget.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/welcome_widget.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Welcome(),
//                   SizedBox(height: 10),
//                   //SearchInputWidget(),
//                 ],
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: BannerWidget(),
//             ),
//           ];
//         },
//         body: CategoryText(),
//       ),
//     );
//   }
// }
