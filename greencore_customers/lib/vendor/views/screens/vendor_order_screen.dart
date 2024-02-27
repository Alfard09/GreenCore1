// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:intl/intl.dart';

// class VendorOrderScreen extends StatelessWidget {
//   String formattedDate(date) {
//     final outputDateFormat = DateFormat('dd/MM/yyyy');

//     final outputDate = outputDateFormat.format(date);

//     return outputDate;
//   }

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
//         .collection('orders')
//         .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .snapshots();
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xff42275a),
//         elevation: 1,
//         title: Center(
//           child: Text(
//             'My Orders',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _ordersStream,
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Something went wrong');
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xff42275a),
//               ),
//             );
//           }

//           return ListView(
//             children: snapshot.data!.docs.map((DocumentSnapshot document) {
//               return Slidable(
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.white,
//                         radius: 14,
//                         child: document['accepted'] == true
//                             ? Icon(Icons.delivery_dining)
//                             : Icon(Icons.access_time),
//                       ),
//                       title: document['accepted'] == true
//                           ? Text(
//                               'Accepted',
//                               style: TextStyle(color: Colors.green.shade700),
//                             )
//                           : Text(
//                               'Not Accepted',
//                               style: TextStyle(color: Colors.red.shade700),
//                             ),
//                       trailing: Text(
//                         'Amount' +
//                             " " +
//                             document['productPrice'].toStringAsFixed(2),
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.blueGrey,
//                         ),
//                       ),
//                       subtitle: Text(
//                         formattedDate(
//                           document['orderDate'].toDate(),
//                         ),
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueGrey,
//                         ),
//                       ),
//                     ),
//                     ExpansionTile(
//                       title: Text(
//                         'Order Details',
//                         style: TextStyle(
//                           color: Color(0xff42275a),
//                           fontSize: 15,
//                         ),
//                       ),
//                       subtitle: Text('View Order Details'),
//                       children: [
//                         ListTile(
//                           leading: CircleAvatar(
//                             child: Image.network(
//                               document['productImage'][0],
//                             ),
//                           ),
//                           title: Text(document['productName']),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Text(
//                                     'Quantity',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     document['selectedQuantity']
//                                         .toString(), //selectedQuantity //queantity
//                                   ),
//                                 ],
//                               ),
//                               document['accepted'] == true
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         Text('Schedule Delivery Date'),
//                                         Text(
//                                           formattedDate(
//                                             document['scheduleDate'].toDate(),
//                                           ),
//                                         )
//                                       ],
//                                     )
//                                   : Text(''),
//                               ListTile(
//                                 title: Text(
//                                   'Buyer Details',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(document['fullName']),
//                                     Text(document['email']),
//                                     Text(document['address']),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Divider(
//                       thickness: 2,
//                     ),
//                   ],
//                 ),
//                 startActionPane: ActionPane(
//                   motion: const ScrollMotion(),
//                   children: [
//                     SlidableAction(
//                       onPressed: (context) async {
//                         await _firestore
//                             .collection('orders')
//                             .doc(document['orderId'])
//                             .update({
//                           'accepted': false,
//                         });
//                       },
//                       backgroundColor: Color(0xFFFE4A49),
//                       foregroundColor: Colors.white,
//                       icon: Icons.delete,
//                       label: 'Reject',
//                     ),
//                     SlidableAction(
//                       onPressed: (context) async {
//                         await _firestore
//                             .collection('orders')
//                             .doc(document['orderId'])
//                             .update({
//                           'accepted': true,
//                         });
//                       },
//                       backgroundColor: Color(0xFF21B7CA),
//                       foregroundColor: Colors.white,
//                       icon: Icons.add_outlined,
//                       label: 'Accept',
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:greencore_1/vendor/views/screens/vendor_inner_screen/orderdetail_track.dart';
import 'package:intl/intl.dart';

class VendorOrderScreen extends StatelessWidget {
  String formattedDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');
    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff42275a),
        elevation: 1,
        title: Center(
          child: Text(
            'My Orders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xff42275a),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OrderTrackingPage(
                        orderId: document['orderId'],
                      );
                    }));
                  },
                  child: Slidable(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: document['accepted'] == true
                                ? Icon(Icons.delivery_dining)
                                : Icon(Icons.access_time),
                          ),
                          title: document['accepted'] == true
                              ? Text(
                                  'Orders Confirmed',
                                  style:
                                      TextStyle(color: Colors.green.shade700),
                                )
                              : Text(
                                  'waiting for Confirmation'), // Empty container for not accepted orders
                          trailing: Text(
                            'Amount' +
                                " " +
                                document['productPrice'].toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                          subtitle: Text(
                            formattedDate(
                              document['orderDate'].toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        //
                        // ExpansionTile(
                        //   title: Text(
                        //     'Order Details',
                        //     style: TextStyle(
                        //       color: Color(0xff42275a),
                        //       fontSize: 15,
                        //     ),
                        //   ),
                        //   subtitle: Text('View Order Details'),
                        //   children: [
                        //     ListTile(
                        //       leading: CircleAvatar(
                        //         child: Image.network(
                        //           document['productImage'][0],
                        //         ),
                        //       ),
                        //       title: Text(document['productName']),
                        //       subtitle: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceAround,
                        //             children: [
                        //               Text(
                        //                 'Quantity',
                        //                 style: TextStyle(
                        //                   fontSize: 14,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 document['selectedQuantity']
                        //                     .toString(), //selectedQuantity //queantity
                        //               ),
                        //             ],
                        //           ),
                        //           document['accepted'] == true
                        //               ? Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceEvenly,
                        //                   children: [
                        //                     Text('Schedule Delivery Date'),
                        //                     Text(
                        //                       formattedDate(
                        //                         document['scheduleDate'].toDate(),
                        //                       ),
                        //                     )
                        //                   ],
                        //                 )
                        //               : Container(), // Empty container for not accepted orders
                        //           ListTile(
                        //             title: Text(
                        //               'Buyer Details',
                        //               style: TextStyle(
                        //                 fontSize: 18,
                        //               ),
                        //             ),
                        //             subtitle: Column(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(document['fullName']),
                        //                 Text(document['email']),
                        //                 Text(document['address']),
                        //               ],
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                        // //
                        SizedBox(height: 10),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    ),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        // Commented out reject action
                        // SlidableAction(
                        //   onPressed: (context) async {
                        //     await _firestore
                        //         .collection('orders')
                        //         .doc(document['orderId'])
                        //         .update({
                        //       'accepted': false,
                        //     });
                        //   },
                        //   backgroundColor: Color(0xFFFE4A49),
                        //   foregroundColor: Colors.white,
                        //   icon: Icons.delete,
                        //   label: 'Reject',
                        // ),
                        SlidableAction(
                          onPressed: (context) async {
                            await _firestore
                                .collection('orders')
                                .doc(document['orderId'])
                                .update({
                              'accepted': true,
                            });
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.add_outlined,
                          label: 'Accept',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
