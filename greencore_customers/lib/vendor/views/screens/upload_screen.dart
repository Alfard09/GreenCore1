// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:greencore_1/provider/product_provider.dart';
// import 'package:greencore_1/vendor/views/screens/main_vendor_screen.dart';
// import 'package:greencore_1/vendor/views/screens/upload_tab_screens/attributes_tab_screen.dart';
// import 'package:greencore_1/vendor/views/screens/upload_tab_screens/general_tab_screen.dart';
// import 'package:greencore_1/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
// import 'package:greencore_1/vendor/views/screens/upload_tab_screens/plant_specification_tab_screen.dart';
// import 'package:greencore_1/vendor/views/screens/upload_tab_screens/shipping_tab_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

// class UploadScreen extends StatelessWidget {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     final ProductProvider _productProvider =
//         Provider.of<ProductProvider>(context);
//     return DefaultTabController(

//       length: 5,
//       child: Form(
//         key: _formKey,
//         child: Scaffold(
//           appBar: AppBar(

//             backgroundColor: Color(0xff42275a),
//             elevation: 0,
//             bottom: TabBar(indicatorColor: Colors.white, tabs: [

//               Tab(
//                 child: Text(
//                   'General',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Shipping',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Attribute',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Tab(
//                 child: Text(
//                   'Images',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//               Tab(
//                 child: Text('Specifications'),
//               ),
//             ]),
//           ),
//           body: TabBarView(
//             children: [
//             GeneralScreen(),
//             ShippingScreen(),
//             AttributesScreen(),
//             ImagesScreen(),
//             SpecificationScreen(),
//           ]),
//           bottomSheet: Container(
//             color: Colors.white70,
//             child: Padding(
//               padding: const EdgeInsets.all(6.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 199, 199, 198)),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     EasyLoading.show();
//                     final productId = Uuid().v4();

//                     await _firestore.collection('products').doc(productId).set({
//                       'productId': productId,
//                       'productName':
//                           _productProvider.productData['productName'],
//                       'productPrice':
//                           _productProvider.productData['productPrice'],
//                       'quantity': _productProvider.productData['quantity'],
//                       'category': _productProvider.productData['category'],
//                       'description':
//                           _productProvider.productData['description'],
//                       'imageUrlList':
//                           _productProvider.productData['imageUrlList'],
//                       'scheduleDate':
//                           _productProvider.productData['scheduleDate'],
//                       'chargeShipping':
//                           _productProvider.productData['chargeShippping'],
//                       'shippingCharge':
//                           _productProvider.productData['shippingCharge'],
//                       'brandName': _productProvider.productData['brandName'],
//                       'sizeList': _productProvider.productData['sizeList'],
//                       'vendorId': FirebaseAuth.instance.currentUser!.uid,
//                     }).whenComplete(() {
//                       _productProvider.clearData();
//                       _formKey.currentState!.reset();
//                       EasyLoading.dismiss();
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) {
//                         return MainVendorScreen();
//                       }));
//                     });

//                     // print(_productProvider.productData['productName']);
//                     // print(_productProvider.productData['productPrice']);
//                     // print(_productProvider.productData['quantity']);
//                     // print(_productProvider.productData['category']);
//                     // print(_productProvider.productData['description']);
//                     // print(_productProvider.productData['imageUrlList']);
//                     // print(_productProvider.productData['chargeShippping']);
//                     // print(_productProvider.productData['shippingCharge']);
//                     // print(_productProvider.productData['brandName']);
//                     // print(_productProvider.productData['sizeList']);
//                   }
//                 },
//                 child: Text(
//                   'Save',
//                   style: TextStyle(color: Colors.purple),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/provider/product_provider.dart';
import 'package:greencore_1/vendor/views/screens/main_vendor_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/attributes_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/care_tips_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/general_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/images_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/offer_tab_screen.dart';
import 'package:greencore_1/vendor/views/screens/upload_tab_screens/plant_specification_tab_screen.dart';
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
      length: 7,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff42275a),
            elevation: 0,
            title: Text('Upload Screen'),
            bottom: TabBar(
              isScrollable: true, // Make tabs scrollable
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: 'General',
                ),
                Tab(
                  text: 'Shipping',
                ),
                Tab(
                  text: 'Attribute',
                ),
                Tab(
                  text: 'Images',
                ),
                Tab(
                  text: 'Specifications',
                ),
                Tab(
                  text: 'Offers',
                ),
                Tab(
                  text: 'Plant Care Tips',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GeneralScreen(),
              ShippingScreen(),
              AttributesScreen(),
              ImagesScreen(),
              SpecificationScreen(),
              OfferScreen(),
              CareTips(),
            ],
          ),
          bottomSheet: Container(
            color: Colors.white70,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 199, 199, 198)),
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
                      'vendorId': FirebaseAuth.instance.currentUser!.uid,
                      //discount
                      'discount': _productProvider.productData['discount'],
                      'discountPrice':
                          _productProvider.productData['discountPrice'],
                      //specifications
                      'isPlantSpecification':
                          _productProvider.productData['isPlantSpecification'],
                      'plantHeight':
                          _productProvider.productData['plantHeight'],
                      'plantSpread':
                          _productProvider.productData['plantSpread'],
                      'commonName': _productProvider.productData['commonName'],
                      'maxHeight': _productProvider.productData['maxHeight'],
                      'flowerColor':
                          _productProvider.productData['flowerColor'],
                      'bloomTime': _productProvider.productData['bloomTime'],
                      'diffLevel': _productProvider.productData['diffLevel'],
                      'scientificName':
                          _productProvider.productData['scientificName'],
                      'specialFeatures':
                          _productProvider.productData['specialFeatures'],
                      'uses': _productProvider.productData['uses'],
                      //care tips
                      'isCareTip': _productProvider.productData['isCareTip'],
                      'plantCareTips':
                          _productProvider.productData['plantCaretip'],
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
                    // print(_productProvider.productData['discount']);
                    // print(_productProvider.productData['discountPrice']);
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
