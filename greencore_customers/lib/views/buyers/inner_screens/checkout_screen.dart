import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:greencore_1/models/cart_attribute.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:greencore_1/views/buyers/inner_screens/edit_profile_screen.dart';
import 'package:greencore_1/views/buyers/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/show_snackBar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  //payment
  late Razorpay _razorpay;
  late FirebaseFirestore _firestore;
  late CartProvider _cartProvider;
  late CollectionReference users;
  late CollectionReference vendors;
  late Map<String, dynamic> data;

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final CartProvider _cartProvider = Provider.of<CartProvider>(context);
  // CollectionReference users = FirebaseFirestore.instance.collection('buyers');
  bool isPaymentComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    users = FirebaseFirestore.instance.collection('buyers');
    vendors = FirebaseFirestore.instance.collection('vendors');

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handdlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handdlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handdlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handdlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handdlePaymentSuccess(PaymentSuccessResponse response) {
    // setState(() {
    //   isPaymentComplete = true;
    // });
    // _updateProductQuantityInOrdersCollection();
    _updateProductQuantityInProductsCollection();
    _placeOrder();
  }

  void _handdlePaymentError(PaymentFailureResponse response) {
    EasyLoading.showError('Payment Failed. Please try ');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    //External wallet logic
    EasyLoading.showError('Payment Failed. Please try again.');
  }

  // void _updateProductQuantityInOrdersCollection() {
  //   _cartProvider.getCartItem.forEach((key, item) {
  //     final orderId = Uuid().v4();
  //     FirebaseFirestore.instance.collection('orders').doc(orderId).set({
  //       // Existing order data...
  //       'selectedQuantity': item.quantity,
  //       // Update product quantity by subtracting selected quantity
  //       'quantity': item.productQuantity - item.quantity,
  //       // Other fields...
  //     });
  //   });
  // }

  void _updateProductQuantityInProductsCollection() {
    _cartProvider.getCartItem.forEach((key, item) {
      FirebaseFirestore.instance
          .collection('products')
          .doc(item.productId)
          .update({
        // Update product quantity by subtracting selected quantity
        'quantity': item.productQuantity - item.quantity,
        // Other fields...
      });
    });
  }

  void _placeOrder() {
    EasyLoading.show(status: 'Placing Order');
    //to place order
    _cartProvider.getCartItem.forEach((key, item) {
      final orderId = Uuid().v4();
      FirebaseFirestore.instance.collection('orders').doc(orderId).set({
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
        'selectedQuantity':
            item.quantity, //to see the selected quantity in the cart
        'productSize': item.productSize,
        'scheduleDate': item.scheduleDate,
        'status': 'Order Placed',
        'orderDate': DateTime.now(),
        'accepted': false,
        'totalPrice': item.price * item.quantity,
        'fullPrice':
            item.price * item.quantity //for full price in the earning screen
      }).whenComplete(() {
        _updateSellerBalance(item);
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
  }

  Future<void> _updateSellerBalance(CartAttr item) async {
    try {
      // Fetch the seller's document
      DocumentReference vendorRef =
          FirebaseFirestore.instance.collection('vendors').doc(item.vendorId);
      DocumentSnapshot vendorDoc = await vendorRef.get();

      if (vendorDoc.exists) {
        // Get the current balance
        double currentBalance =
            (vendorDoc.data() as Map<String, dynamic>)['balance'] ?? 0.0;
        double currentFullPrice =
            (vendorDoc.data() as Map<String, dynamic>)['fullPrice'] ?? 0.0;

        // Calculate the new balance after deducting the total price of the ordered products
        double newBalance = currentBalance + (item.price * item.quantity);
        double newFullPrice = currentFullPrice + (item.price * item.quantity);

        // Update the seller's document with the new balance
        await vendorRef.set({
          'balance': newBalance,
          'fullPrice': newFullPrice,
        }, SetOptions(merge: true));

        print(
            'Seller balance updated successfully: $newBalance  $newFullPrice');
      } else {
        print('Seller document with ID ${item.vendorId} does not exist');
      }
    } catch (e) {
      print('Error updating seller balance: $e');
    }
  }

  // Future<void> _updateSellerBalance(CartAttr item) async {
  //   try {
  //     // Fetch the seller's document
  //     DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
  //         .collection('vendors')
  //         .doc(item.vendorId)
  //         .get();
  //     if (sellerDoc.exists) {
  //       // Get the current balance
  //       double currentBalance = sellerDoc['balance'] ?? 0.0;

  //       // Calculate the new balance after deducting the total price of the ordered products
  //       double newBalance =
  //           currentBalance + (item.productQuantity * item.quantity);

  //       // Update the seller's document with the new balance
  //       await FirebaseFirestore.instance
  //           .collection('vendors')
  //           .doc(item.vendorId)
  //           .update({
  //         'balance': newBalance,
  //       });
  //     } else {
  //       print('Seller document does not exist');
  //     }
  //   } catch (e) {
  //     print('Error updating seller balance: $e');
  //   }
  // }

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
          // Map<String, dynamic> data =
          //     snapshot.data!.data() as Map<String, dynamic>;
          data = snapshot.data!.data() as Map<String, dynamic>;
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.green.shade600,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 1,
                  title: Text(
                    'Checkout',
                    style:
                        TextStyle(color: Colors.green.shade600, fontSize: 18),
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
                                      child:
                                          Image.network(cartData.imageUrl[0]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
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
                                          "₹" +
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
                                                    color:
                                                        Colors.green.shade600,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                bottomSheet: data['address'] == null
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
                            if (!isPaymentComplete) {
                              // Initiate Razorpay payment
                              _initiateRazorpayPayment(data);
                            } else {
                              // Payment already complete, place order
                              _placeOrder();
                            }

                            // EasyLoading.show(status: 'Placing Order');
                            // //to place order
                            // _cartProvider.getCartItem.forEach((key, item) {
                            //   final orderId = Uuid().v4();
                            //   _firestore.collection('orders').doc(orderId).set({
                            //     'orderId': orderId,
                            //     'vendorId': item.vendorId,
                            //     'email': data['email'],
                            //     'phone': data['phoneNumber'],
                            //     'address': data['address'],
                            //     'buyerId': data['buyerId'],
                            //     'fullName': data['fullName'],
                            //     'buyerPhoto': data['profileImage'],
                            //     'productName': item.productName,
                            //     'productPrice': item.price,
                            //     'productId': item.productId,
                            //     'productImage': item.imageUrl,
                            //     'quantity': item.productQuantity,
                            //     'selectedQuantity': item
                            //         .quantity, //to see the selected quantity in the cart
                            //     'productSize': item.productSize,
                            //     'scheduleDate': item.scheduleDate,
                            //     'orderDate': DateTime.now(),
                            //     'accepted': false,
                            //   }).whenComplete(() {
                            //     setState(() {
                            //       _cartProvider.getCartItem.clear();
                            //     });
                            //     EasyLoading.dismiss();
                            //     Navigator.pushReplacement(context,
                            //         MaterialPageRoute(builder: (context) {
                            //       return MainScreen();
                            //     }));
                            //   });
                            // });
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
              ),
              Positioned(
                // top: AppBar().preferredSize.height + 8,
                left: 0,
                right: 0,
                bottom: 70,
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.green.shade600,
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹" +
                                " " +
                                "${cartProvider.totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
//funct1

  void _initiateRazorpayPayment(Map<String, dynamic> userData) {
    EasyLoading.show(status: 'Initiating Payment');

    // Get the total amount from the cartProvider
    double totalAmount = _cartProvider.totalPrice;

    var options = {
      'key': 'rzp_test_Comn0zj0qREnFo', // Replace with your actual Razorpay key
      'amount': (totalAmount * 100).toInt(), // Amount should be in paise
      'name': 'GreenCore',
      'description': 'Payment for Order',
      'prefill': {
        'contact': userData['phoneNumber'],
        'email': userData['email'],
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error in initiating payment: $e');
      EasyLoading.dismiss();
    }
  }
}
