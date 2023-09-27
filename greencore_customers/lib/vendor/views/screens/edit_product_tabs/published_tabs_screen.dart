import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:greencore_1/vendor/views/screens/vedorProductDetail/vendor_product_detail_screen.dart';

class PublishedTabScreen extends StatelessWidget {
  // const PublishedTabScreen({super.key});
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorProductStream = FirebaseFirestore
        .instance
        .collection('products')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('approved', isEqualTo: true)
        .snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorProductStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final _vendorProductStream = snapshot.data!.docs[index];
                  return Slidable(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return VendorProductDetailScreen(
                            productData: _vendorProductStream,
                          );
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: Image.network(
                                  _vendorProductStream['imageUrlList'][0]),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      _vendorProductStream['productName'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff42275a)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "\$" +
                                        " " +
                                        _vendorProductStream['productPrice']
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      //dismissible: DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          flex: 2,
                          onPressed: (context) async {
                            await _fireStore
                                .collection('products')
                                .doc(_vendorProductStream['productId'])
                                .update({
                              'approved': false,
                            });
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.approval,
                          label: 'Unpublish  ',
                        ),
                        SlidableAction(
                          flex: 2,
                          onPressed: (context) async {
                            await _fireStore
                                .collection('products')
                                .doc(_vendorProductStream['productId'])
                                .delete();
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    // endActionPane: ActionPane(
                    //   motion: ScrollMotion(),
                    //   children: [
                    //     SlidableAction(
                    //       // An action can be bigger than the others.
                    //       flex: 2,
                    //       onPressed: (context) {},
                    //       backgroundColor: Color(0xFF7BC043),
                    //       foregroundColor: Colors.white,
                    //       icon: Icons.archive,
                    //       label: 'Archive',
                    //     ),
                    //     SlidableAction(
                    //       onPressed: (context) {},
                    //       backgroundColor: Colors.red,
                    //       foregroundColor: Colors.white,
                    //       icon: Icons.save,
                    //       label: 'Save',
                    //     ),
                    //   ],
                    // ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    //child: const ListTile(title: Text('Slide me')),
                  );
                }),
          );
        },
      ),
    );
  }
}
