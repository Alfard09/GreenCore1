import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/screens/edit_product_tabs/published_tabs_screen.dart';
import 'package:greencore_1/vendor/views/screens/edit_product_tabs/unpublished_tabs_screen.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 1,
          title: Center(
            child: Text(
              'Manage Products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Color(0xff42275a),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text('Published'),
              ),
              Tab(
                child: Text('Unpublished'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PublishedTabScreen(),
            UnpublishedTabScreen(),
          ],
        ),
      ),
    );
  }
}
