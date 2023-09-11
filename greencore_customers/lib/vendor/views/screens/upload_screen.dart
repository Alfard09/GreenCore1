import 'package:flutter/material.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/general_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/shipping_tab_screen.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
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
        bottomSheet: Container(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () {
                print(_productProvider.productData['productName']);
                print(_productProvider.productData['productPrice']);
                print(_productProvider.productData['quantity']);
                print(_productProvider.productData['category']);
                print(_productProvider.productData['description']);
                print(_productProvider.productData['imageUrlList']);
                print(_productProvider.productData['chargeShippping']);
                print(_productProvider.productData['shippingCharge']);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
