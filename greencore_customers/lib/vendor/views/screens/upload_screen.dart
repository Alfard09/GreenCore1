import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/general_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/shipping_tab_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff42275a),
          elevation: 0,
          bottom: TabBar(indicatorColor: Colors.white, tabs: [
            Tab(
              child: Text(
                'General',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Shipping',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Attribute',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Images',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          GeneralScreen(),
          ShippingScreen(),
          AttributesScreen(),
          ImagesScreen(),
        ]),
      ),
    );
  }
}
