import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:greencore_1/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/show_snackBar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.green.shade600,
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              title: Text(
                'Checkout',
                style: TextStyle(color: Colors.green.shade600, fontSize: 18),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: ((context, index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Card(
                      elevation: 2,
                      child: SizedBox(
                        height: 150,
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(cartData.imageUrl[0]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: Text(
                                        cartData.productName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Text(
                                      "\$" +
                                          " " +
                                          cartData.price.toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                    if (cartData.productSize != null &&
                                        cartData.productSize!.isNotEmpty)
                                      Container(
                                        height: 25,
                                        width: 50,
                                        child: OutlinedButton(
                                          onPressed: null,
                                          child: Text(
                                            cartData.productSize.toString(),
                                            style: TextStyle(
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.w600),
                                            // Use an empty string if null
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            bottomSheet: data['address'] == ''
                ? TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditProfileScreen(
                          userData: data,
                        );
                      })).whenComplete(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Enter the billing Address'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: InkWell(
                      onTap: () {
                        EasyLoading.show(status: 'Placing Order');
                        //to place order
                        _cartProvider.getCartItem.forEach((key, item) {
                          final orderId = Uuid().v4();
                          _firestore.collection('orders').doc(orderId).set({
                            'orderId': orderId,
                            'vendorId': item.vendorId,
                            'email': data['email'],
                            'phone': data['phoneNumber'],
                            'address': data['address'],
                            'buyerId': data['buyerId'],
                            'fullName': data['fullName'],
                            'buyerPhoto': data['profileImage'],
                            'productName': item.productName,
                            'productPrice': item.price,
                            'productId': item.productId,
                            'productImage': item.imageUrl,
                            'quantity': item.productQuantity,
                            'selectedQuantity': item
                                .quantity, //to see the selected quantity in the cart
                            'productSize': item.productSize,
                            'scheduleDate': item.scheduleDate,
                            'orderDate': DateTime.now(),
                          }).whenComplete(() {
                            setState(() {
                              _cartProvider.getCartItem.clear();
                            });
                            EasyLoading.dismiss();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return MainScreen();
                            }));
                          });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Text(
                            // "\$" +
                            //     " " +
                            //     _cartProvider.totalPrice.toStringAsFixed(2) +
                            //     "  " +
                            'PLACE ORDER',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
