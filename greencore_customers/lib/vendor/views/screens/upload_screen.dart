import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/vendor/views/screens/main_vendor_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/general_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/shipping_tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    EasyLoading.show();
                    final productId = Uuid().v4();

                    await _firestore.collection('products').doc(productId).set({
                      'productId': productId,
                      'productName':
                          _productProvider.productData['productName'],
                      'productPrice':
                          _productProvider.productData['productPrice'],
                      'quantity': _productProvider.productData['quantity'],
                      'category': _productProvider.productData['category'],
                      'description':
                          _productProvider.productData['description'],
                      'imageUrlList':
                          _productProvider.productData['imageUrlList'],
                      'scheduleDate':
                          _productProvider.productData['scheduleDate'],
                      'chargeShipping':
                          _productProvider.productData['chargeShippping'],
                      'shippingCharge':
                          _productProvider.productData['shippingCharge'],
                      'brandName': _productProvider.productData['brandName'],
                      'sizeList': _productProvider.productData['sizeList'],
                    }).whenComplete(() {
                      _productProvider.clearData();
                      _formKey.currentState!.reset();
                      EasyLoading.dismiss();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MainVendorScreen();
                      }));
                    });

                    // print(_productProvider.productData['productName']);
                    // print(_productProvider.productData['productPrice']);
                    // print(_productProvider.productData['quantity']);
                    // print(_productProvider.productData['category']);
                    // print(_productProvider.productData['description']);
                    // print(_productProvider.productData['imageUrlList']);
                    // print(_productProvider.productData['chargeShippping']);
                    // print(_productProvider.productData['shippingCharge']);
                    // print(_productProvider.productData['brandName']);
                    // print(_productProvider.productData['sizeList']);
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
