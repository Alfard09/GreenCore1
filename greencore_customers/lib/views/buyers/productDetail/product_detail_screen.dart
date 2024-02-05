import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/provider/cart_provider.dart';
import 'package:greencore_1/utils/show_snackBar.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  // const ProductDetailScreen({super.key});
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

int _imageIndex = 0;
String? _selectedSize;

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String formatedDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');

    final outputDate = outputDateFormat.format(date);

    return outputDate;
  }

  Future<void> _toggleWishlist() async {
    // Check if the product is already in the wishlist
    bool isInWishlist = await _checkIfInWishlist();

    if (isInWishlist) {
      _removeFromWishlist();
    } else {
      _addToWishlist();
    }
  }

  Future<bool> _checkIfInWishlist() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('wishlist')
        .where('productId', isEqualTo: widget.productData['productId'])
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // void _addToWishlist() async {
  //   await FirebaseFirestore.instance.collection('wishlist').add({
  //     'productName': widget.productData['productName'],
  //     'productImage': widget.productData['imageUrlList'][0],
  //     'productPrice': widget.productData['productPrice'],
  //     'productId': widget.productData['productId'],
  //     'isWishlist': true,
  //   });
  //   showSnack(context, 'Item added to wishlist');
  // }
  void _addToWishlist() async {
    String? buyerId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('wishlist').add({
      'buyerId': buyerId,
      'productName': widget.productData['productName'],
      'Image': widget.productData['imageUrlList'][0],
      'productPrice': widget.productData['productPrice'],
      'productId': widget.productData['productId'],
    });
    showSnack(context, 'Item added to wishlist');
  }

  void _removeFromWishlist() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('wishlist')
        .where('productId', isEqualTo: widget.productData['productId'])
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String documentId = querySnapshot.docs.first.id;

      // Use the delete method to remove the document from the wishlist
      await FirebaseFirestore.instance
          .collection('wishlist')
          .doc(documentId)
          .delete();
      setState(() {});
      showSnack(context, 'Item removed from wishlist');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.productData.data());
    String productName = widget.productData['productName'];
    print('Product Name: $productName');

    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          widget.productData['productName'],
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     _toggleWishlist();
          //   },
          //   icon: Icon(
          //     widget.productData['isWishlist']
          //         ? Icons.favorite
          //         : Icons.favorite_border,
          //     color: widget.productData['isWishlist'] ? Colors.red : null,
          //   ),
          // )
          // Modify the IconButton code
          IconButton(
            onPressed: () async {
              await _toggleWishlist();
              setState(
                  () {}); // Ensure the UI updates after the wishlist operation
            },
            icon: FutureBuilder<bool>(
              // Use a FutureBuilder to determine the icon based on whether it's in the wishlist
              future: _checkIfInWishlist(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  bool isInWishlist = snapshot.data ?? false;
                  return Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isInWishlist ? Colors.red : null,
                  );
                } else {
                  return Icon(Icons.favorite_border);
                  // You can return a loading indicator or default icon while the future is resolving
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              child: PageView.builder(
                itemCount: widget.productData['imageUrlList'].length,
                physics: BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _imageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    height: 300,
                    width: double.infinity,
                    child: PhotoView(
                      imageProvider: NetworkImage(
                        widget.productData['imageUrlList'][index],
                      ),
                      backgroundDecoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Stack(
            //   fit: StackFit.loose,
            //   children: [
            //     Container(
            //       height: 300,
            //       //width: MediaQuery.of(context).size.width,
            //       width: double.infinity,
            //       // color: Colors.white,
            //       child: PhotoView(
            //         imageProvider: NetworkImage(
            //           widget.productData['imageUrlList'][_imageIndex],
            //           // (widget.productData['imageUrlList'] as List<dynamic>?)
            //           //         ?.elementAt(_imageIndex) ??
            //           //     '',
            //         ),
            //         backgroundDecoration: BoxDecoration(
            //           color: Colors.white,
            //           // Set the background color.
            //         ),
            //       ),
            //     ),
            //     Positioned(
            //       bottom: 0,
            //       // left: 0,
            //       right: 0,
            //       // top: 100,
            //       child: Container(
            //         height: 50,
            //         //width: MediaQuery.of(context).size.width,
            //         width: MediaQuery.of(context).size.width,
            //         child: ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             //itemCount: (widget.productData['imageUrlList'] as List<dynamic>?)?.length ?? 0,
            //             itemCount: widget.productData['imageUrlList'].length,
            //             itemBuilder: ((context, index) {
            //               //final imageUrlList =
            //               widget.productData['imageUrlList'] as List<dynamic>?;
            //               //print("Index: $index");
            //               //print("Image URL List: $imageUrlList");

            //               return InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     _imageIndex = index;
            //                   });
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(0.0),
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                         border: Border.all(color: Colors.white)),
            //                     height: 50,
            //                     width: 50,
            //                     child: Image.network(
            //                       widget.productData['imageUrlList'][index],
            //                       fit: BoxFit.cover,
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             })),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 10),
              child: Text(
                widget.productData['productName'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Text(
                "by" + " " + widget.productData['brandName'],
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
              child: Text(
                "\$" +
                    " " +
                    widget.productData['productPrice'].toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade600,
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product will be shipping on:',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    formatedDate(widget.productData['scheduleDate'].toDate()),
                    style: TextStyle(color: Colors.green.shade600),
                  ),
                ],
              ),
            ),

            Divider(),

            widget.productData['sizeList'] == null
                ? Container()
                : ExpansionTile(
                    title: Text("Avaliable Size: "),
                    children: [
                      Container(
                        height: 50,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productData['sizeList'].length,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: _selectedSize ==
                                          widget.productData['sizeList']
                                      ? Colors.green.shade600
                                      : null,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedSize = widget
                                            .productData['sizeList'][index];
                                      });
                                      print(_selectedSize);
                                    },
                                    child: Text(
                                      widget.productData['sizeList'][index],
                                    ),
                                  ),
                                ),
                              );
                            })),
                      )
                    ],
                  ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.productData['description'],
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: Color.fromARGB(164, 10, 10, 10),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Divider(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Center(
                          child: Text(
                            'Plant Care Tips',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18, // Adjust font size
                              color: Colors.green, // Adjust text color
                            ),
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.all(10.0), // Adjust padding as needed
                        content: Container(
                          width: double.infinity,
                          // width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Tip 1: Water the plant regularly.'),
                                Text('Tip 2: Provide adequate sunlight.'),
                                Text('Tip 3: Use appropriate fertilizer.')
                                // Add more tips or content as needed
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: Colors.green, // Adjust text color
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white, // Background color of the button
                  //: Colors.green, // Color of the text when pressed
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Adjust border radius
                  ),
                ),
                child: Text(
                  'Plant Care Tips',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Text color
                  ),
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.speaker_notes_outlined,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Plant Specifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            //table
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: DataTable(
                  dataRowHeight: 40,
                  headingRowHeight: 0,
                  horizontalMargin: 5,
                  border: TableBorder.all(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.green.shade200),
                  columns: [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text(''))
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text(
                        'Plant Spread',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                      DataCell(
                        Text(
                          widget.productData['plantSpread'],
                        ),
                      ),
                    ]),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Plant Height',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Text(
                            widget.productData['plantHeight'],
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Common Name',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Text(
                            widget.productData['commonName'],
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Max Height',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                        DataCell(
                          Text(
                            widget.productData['maxHeight'],
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Flower Color',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Text(
                            widget.productData['flowerColor'],
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Bloom Time',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Text(
                            widget.productData['bloomTime'],
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Difficulty Level',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Text(
                            widget.productData['diffLevel'],
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text(
                          'Scientific Name',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          Text(
                            widget.productData['scientificName'],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.import_export_rounded,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Special Features',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.productData['specialFeatures'],
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: Color.fromARGB(164, 10, 10, 10),
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.eco_rounded,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'uses',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.productData['uses'],
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: Color.fromARGB(164, 10, 10, 10),
                ),
                textAlign: TextAlign.justify,
              ),
            ),

            // ExpansionTile(
            //   tilePadding: EdgeInsets.only(left: 10, right: 10),
            //   //expandedCrossAxisAlignment: CrossAxisAlignment.start,
            //   expandedAlignment: Alignment.topLeft,
            //   leading: Icon(
            //     Icons.library_books_sharp,
            //     color: Colors.green.shade600,
            //   ),
            //   title: Container(
            //     padding: EdgeInsets.all(0),
            //     child: Text(
            //       'Plant Specifications',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 16,
            //       ),
            //       textAlign: TextAlign.left,
            //     ),
            //   ),
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(12.0),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(3),
            //           border: Border.all(),
            //         ),
            //         child: DataTable(
            //           dataRowHeight: 30,
            //           headingRowHeight: 0,
            //           horizontalMargin: 5,
            //           border: TableBorder.all(
            //               borderRadius: BorderRadius.circular(3)),
            //           columns: [
            //             DataColumn(label: Text('')),
            //             DataColumn(label: Text(''))
            //           ],
            //           rows: [
            //             DataRow(cells: [
            //               DataCell(Text(
            //                 'Plant Spread',
            //                 style: TextStyle(fontWeight: FontWeight.w500),
            //               )),
            //               DataCell(
            //                 Text(
            //                   widget.productData['plantSpread'],
            //                 ),
            //               ),
            //             ]),
            //             DataRow(cells: [
            //               DataCell(Text(
            //                 'Plant Height',
            //                 style: TextStyle(fontWeight: FontWeight.w500),
            //               )),
            //               DataCell(
            //                 Text(
            //                   widget.productData['plantHeight'],
            //                 ),
            //               ),
            //             ]),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
      bottomSheet: InkWell(
        key: Key('add_to_cart_button'),
        onTap: _cartProvider.getCartItem
                .containsKey(widget.productData['productId'])
            ? null
            : () {
                if (widget.productData['sizeList'] != null) {
                  if (_selectedSize == null) {
                    showErrorSnack(context, 'Please select a Size');
                  } else {
                    _cartProvider.addProductToCart(
                      widget.productData['productName'],
                      widget.productData['productId'],
                      widget.productData['imageUrlList'],
                      // widget.productData['quantity'],
                      1,
                      widget.productData['quantity'],
                      widget.productData['productPrice'],
                      widget.productData['vendorId'],
                      _selectedSize,
                      widget.productData['scheduleDate'],
                    );
                    showSnack(context, 'Item added to cart');
                    setState(() {
                      _selectedSize =
                          null; // Reset _selectedSize after adding to cart
                    });
                  }
                } else {
                  _cartProvider.addProductToCart(
                    widget.productData['productName'],
                    widget.productData['productId'],
                    widget.productData['imageUrlList'],
                    // widget.productData['quantity'],
                    1,
                    widget.productData['quantity'],
                    widget.productData['productPrice'],
                    widget.productData['vendorId'],
                    _selectedSize,
                    widget.productData['scheduleDate'],
                  );
                  showSnack(context, 'Item added to cart');

                  setState(() {
                    _selectedSize =
                        null; // Reset _selectedSize after adding to cart
                  });
                }

                print('Working');
              },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color:
                // _cartProvider.getCartItem
                //         .containsKey(widget.productData['productId'])
                //     ? Colors.grey:
                Colors.white,
            border: Border(
              top: BorderSide(width: 0.5, color: Colors.black45),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.cart,
                size: 22,
              ),
              SizedBox(
                width: 5,
              ),
              _cartProvider.getCartItem
                      .containsKey(widget.productData['productId'])
                  ? Text(
                      'IN CART',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : Text(
                      'ADD TO CART',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
