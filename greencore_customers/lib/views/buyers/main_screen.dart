import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:greencore_1/views/buyers/nav_screens/account_screen.dart';
import 'package:greencore_1/views/buyers/nav_screens/cart_screen.dart';
import 'package:greencore_1/views/buyers/nav_screens/category_screen.dart';
import 'package:greencore_1/views/buyers/nav_screens/home_screen.dart';
import 'package:greencore_1/views/buyers/nav_screens/plantlist_screen.dart';
import 'package:greencore_1/views/buyers/nav_screens/search_screen.dart';
import 'package:greencore_1/views/buyers/nav_screens/store_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  List<Widget> _page = [
    HomeScreen(),
    CategoryScreen(),
    PlantListView(),
    //SearchScreen(),
    CartScreen(),
    AccountScreen(),
  ];
  Future<bool> _onWillPop() async {
    // Always return false to prevent the app from exiting
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Container(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 223, 0, 0),
              border: Border(
                top: BorderSide(
                  color: const Color.fromARGB(255, 201, 201, 201),
                  width: 1.0,
                ),
              ),
            ),
            child: BottomNavigationBar(
                //fixedColor: const Color.fromARGB(255, 63, 49, 8),
                type: BottomNavigationBarType.shifting,
                currentIndex: _pageIndex,
                onTap: (value) {
                  setState(() {
                    _pageIndex = value;
                  });
                },
                unselectedItemColor: Colors.black87,
                selectedItemColor: Colors.green[900],
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home, key: Key('home_icon')),
                    label: 'HOME',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/explore.svg',
                      width: 20,
                    ),
                    label: 'CATEGORY',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_books),
                    label: 'LIBRARY',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: SvgPicture.asset(
                  //     'assets/icons/search.svg',
                  //     width: 20,
                  //   ),
                  //   label: 'SEARCH',
                  // ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/cart.svg',
                      width: 20,
                    ),
                    label: 'CART',
                  ),

                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/account.svg',
                      width: 20,
                    ),
                    label: 'ACCOUNT',
                  ),
                ]),
          ),
        ),
        body: _page[_pageIndex],
      ),
    );
  }
}
