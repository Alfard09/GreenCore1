import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greencore_1/views/buyers/nav_screens/search_screen.dart';

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
              Container(
                child: SvgPicture.asset(
                  'assets/icons/cart.svg',
                  width: 22,
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
