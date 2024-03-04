// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:greencore_1/vendor/views/screens/vendor_inner_screen/withdraw_screen.dart';

// class EarningScreen extends StatefulWidget {
//   const EarningScreen({super.key});

//   @override
//   State<EarningScreen> createState() => _EarningScreenState();
// }

// class _EarningScreenState extends State<EarningScreen> {
//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('vendors');
//     final Stream<QuerySnapshot> _ordersStream =
//         FirebaseFirestore.instance.collection('orders').snapshots();

//     return

//     //
//      FutureBuilder<DocumentSnapshot>(
//       future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }
//         //
//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data =
//               snapshot.data!.data() as Map<String, dynamic>;
//           return Scaffold(
//               appBar: AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: Color(0xff42275a),
//                 elevation: 1,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 title: Row(
//                   children: [
//                     CircleAvatar(
//                       // radius: 60,
//                       backgroundImage: NetworkImage(data['storeImage']),
//                     ),
//                     SizedBox(width: 3),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "Hi, " + data['bussinessName'],
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               body: StreamBuilder<QuerySnapshot>(
//                 stream: _ordersStream,
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Something went wrong');
//                   }

//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Text("Loading");
//                   }
//                   // double totalOrder = 0.0;
//                   // for (var orderItem in snapshot.data!.docs) {
//                   //   totalOrder += orderItem['selectedQuantity'] *
//                   //       orderItem['productPrice'];
//                   // }
//                   int lenOrder = snapshot.data!.docs.length;
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                             height: 150,
//                             width: MediaQuery.of(context).size.width * 0.65,
//                             decoration: BoxDecoration(
//                               color: Color(0xff3f1651),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Text(
//                                     'TOTAL EARNINGS',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Text(
//                                     "₹" +
//                                         " " +
//                                         data['balance'].toStringAsFixed(2),
//                                     //"₹" + " " + totalOrder.toStringAsFixed(2),
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 150,
//                             width: MediaQuery.of(context).size.width * 0.65,
//                             decoration: BoxDecoration(
//                               color: Color(0xff3f1651),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Text(
//                                     "TOTAL ORDERS",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Text(
//                                     lenOrder.toString(),
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 22,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.push(context,
//                                   MaterialPageRoute(builder: (context) {
//                                 return WithdrawalScreen();
//                               }));
//                             },
//                             child: Container(
//                               height: 40,
//                               width: MediaQuery.of(context).size.width / 1.5,
//                               decoration: BoxDecoration(
//                                 color: Color(0xff3f1651),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "Withdraw ",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ));
//         }

//         return Center(
//           child: CircularProgressIndicator(
//             color: Color(0xff42275a),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/vendor/views/screens/vendor_inner_screen/order_report.dart';
import 'package:greencore_1/vendor/views/screens/vendor_inner_screen/withdraw_screen.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');
    final Stream<QuerySnapshot> _ordersStream =
        FirebaseFirestore.instance.collection('orders').snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: users.doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0xff42275a),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff42275a),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(data['storeImage']),
                ),
                SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Hi, " + data['bussinessName'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _ordersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              int lenOrder = snapshot.data!.docs.length;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Container for Balance
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff3f1651),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'EARNINGS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "₹" +
                                          " " +
                                          data['fullPrice'].toStringAsFixed(2),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container for Amount
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff3f1651),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'BALANCE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "₹" +
                                          " " +
                                          data['balance'].toStringAsFixed(2),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 150,
                      //   width: MediaQuery.of(context).size.width * 0.65,
                      //   decoration: BoxDecoration(
                      //     color: Color(0xff3f1651),
                      //     borderRadius: BorderRadius.circular(30),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.all(10.0),
                      //             child: Text(
                      //               'TOTAL EARNINGS',
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.all(10.0),
                      //             child: Text(
                      //               "₹" +
                      //                   " " +
                      //                   data['fullPrice'].toStringAsFixed(2),
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Column(
                      //         children: [
                      //           Padding(
                      //             padding: const EdgeInsets.all(10.0),
                      //             child: Text(
                      //               'BALANCE',
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.all(10.0),
                      //             child: Text(
                      //               "₹" +
                      //                   " " +
                      //                   data['balance'].toStringAsFixed(2),
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 20,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // ),
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          color: Color(0xff3f1651),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OrdersReportPage();
                            }));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "TOTAL ORDERS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  lenOrder.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WithdrawalScreen();
                          }));
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                            color: Color(0xff3f1651),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Withdraw ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
