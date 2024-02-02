import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greencore_1/views/buyers/inner_screens/wishlist.dart';
import 'package:greencore_1/views/buyers/nav_screens/search_screen.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class Welcome extends StatelessWidget {
  const Welcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 25, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/logo_1.png",
            width: 100,
          ),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  WidgetsFlutterBinding.ensureInitialized();
                  await KommunicateFlutterPlugin.buildConversation({
                    'appId': '310455bba239a00856b03f88a8def31e',
                  });
                },
                child: Container(
                  child: Icon(
                    Icons.chat_outlined,
                    color: Color.fromARGB(255, 170, 201, 134),
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return WishlistPage();
                  })));
                },
                child: Container(
                  child: SvgPicture.asset(
                    'assets/icons/favorite.svg',
                    color: Color.fromARGB(255, 170, 201, 134),
                    width: 22,
                  ),
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return SearchScreen();
                  })));
                },
                child: Container(
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    color: Color.fromARGB(255, 170, 201, 134),
                    width: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
