// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class UnpublishedTabScreen extends StatelessWidget {
//   //const UnpublishedTabScreen({super.key});
//   final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore
//         .instance
//         .collection('products')
//         .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .where('approved', isEqualTo: false)
//         .snapshots();
//     return Scaffold(
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _vendorProductStream,
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

//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Text(
//                 'No Unpublished Products!!!',
//                 style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xff42275a)),
//               ),
//             );
//           }
//           return Container(
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data!.docs.length,
//                 itemBuilder: (context, index) {
//                   final _vendorProductStream = snapshot.data!.docs[index];
//                   return Slidable(
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 80,
//                             width: 80,
//                             child: Image.network(
//                                 _vendorProductStream['imageUrlList'][0]),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: MediaQuery.of(context).size.width - 100,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 8.0),
//                                   child: Text(
//                                     _vendorProductStream['productName'],
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       //overflow: TextOverflow.ellipsis,
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xff42275a),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0),
//                                 child: Text(
//                                   "₹" +
//                                       " " +
//                                       _vendorProductStream['productPrice']
//                                           .toStringAsFixed(2),
//                                   style: TextStyle(
//                                       fontSize: 17,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           //Divider(),
//                         ],
//                       ),
//                     ),
//                     // Specify a key if the Slidable is dismissible.
//                     key: const ValueKey(0),

//                     // The start action pane is the one at the left or the top side.
//                     startActionPane: ActionPane(
//                       // A motion is a widget used to control how the pane animates.
//                       motion: const StretchMotion(),

//                       // A pane can dismiss the Slidable.
//                       //dismissible: DismissiblePane(onDismissed: () {}),

//                       // All actions are defined in the children parameter.
//                       children: [
//                         // A SlidableAction can have an icon and/or a label.
//                         SlidableAction(
//                           flex: 2,
//                           onPressed: (context) async {
//                             await _fireStore
//                                 .collection('products')
//                                 .doc(_vendorProductStream['productId'])
//                                 .update({
//                               'approved': true,
//                             });
//                           },
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                           icon: Icons.publish,
//                           label: 'Publish',
//                         ),
//                         SlidableAction(
//                           flex: 2,
//                           onPressed: (context) async {
//                             await _fireStore
//                                 .collection('products')
//                                 .doc(_vendorProductStream['productId'])
//                                 .delete();
//                           },
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                           icon: Icons.delete,
//                           label: 'Delete',
//                         ),
//                       ],
//                     ),

//                     // The end action pane is the one at the right or the bottom side.
//                     // endActionPane: ActionPane(
//                     //   motion: ScrollMotion(),
//                     //   children: [
//                     //     SlidableAction(
//                     //       // An action can be bigger than the others.
//                     //       flex: 2,
//                     //       onPressed: (context) {},
//                     //       backgroundColor: Color(0xFF7BC043),
//                     //       foregroundColor: Colors.white,
//                     //       icon: Icons.archive,
//                     //       label: 'Archive',
//                     //     ),
//                     //     SlidableAction(
//                     //       onPressed: (context) {},
//                     //       backgroundColor: Colors.red,
//                     //       foregroundColor: Colors.white,
//                     //       icon: Icons.save,
//                     //       label: 'Save',
//                     //     ),
//                     //   ],
//                     // ),

//                     // The child of the Slidable is what the user sees when the
//                     // component is not dragged.
//                     //child: const ListTile(title: Text('Slide me')),
//                   );
//                 }),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UnpublishedTabScreen extends StatelessWidget {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> _showConfirmationDialog(
      BuildContext context, String action, DocumentSnapshot product) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to $action this product?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _performAction(action, product);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _performAction(String action, DocumentSnapshot product) {
    if (action == 'Publish') {
      _publishProduct(product);
    } else if (action == 'Delete') {
      _deleteProduct(product);
    }
  }

  void _publishProduct(DocumentSnapshot product) async {
    try {
      await _fireStore
          .collection('products')
          .doc(product.id)
          .update({'approved': true});
    } catch (error) {
      print('Error during publishing: $error');
    }
  }

  void _deleteProduct(DocumentSnapshot product) async {
    try {
      await _fireStore.collection('products').doc(product.id).delete();
    } catch (error) {
      print('Error during delete: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore
        .instance
        .collection('products')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('approved', isEqualTo: false)
        .snapshots();
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _vendorProductStream,
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

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No Unpublished Products!!!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff42275a)),
                  ),
                );
              }
              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color(0xff42275a),
                      ),
                      child: Center(
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TyperAnimatedText('...Swipe right to know more...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final _vendorProductStream =
                              snapshot.data!.docs[index];
                          return Slidable(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.network(
                                        _vendorProductStream['imageUrlList']
                                            [0]),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            _vendorProductStream['productName'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff42275a),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "₹" +
                                              " " +
                                              _vendorProductStream[
                                                      'productPrice']
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            key: ValueKey(_vendorProductStream.id),
                            startActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) {
                                    _showConfirmationDialog(context, 'Publish',
                                        _vendorProductStream);
                                  },
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  icon: Icons.publish,
                                  label: 'Publish',
                                ),
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) {
                                    _showConfirmationDialog(context, 'Delete',
                                        _vendorProductStream);
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
