// import 'package:flutter/material.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/banner_widget.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/category_text.dart';
// import 'package:greencore_1/views/buyers/nav_screens/widgets/welcome_widget.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Welcome(),
//             SizedBox(
//               height: 10,
//             ),
//             // SearchInputWidget(),
//             BannerWidget(),
//             CategoryText(),
//             SizedBox(
//               height: 5,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

//2
import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/welcome_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Welcome(),
              SizedBox(height: 10),
              // SearchInputWidget(),
            ],
          ),
          BannerWidget(),
          CategoryText(),
        ],
      ),
    );
  }
}
