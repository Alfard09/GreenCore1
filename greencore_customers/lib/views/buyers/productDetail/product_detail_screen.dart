import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
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
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  height: 300,
                  //width: MediaQuery.of(context).size.width,
                  width: double.infinity,
                  // color: Colors.white,
                  child: PhotoView(
                    imageProvider: NetworkImage(
                      widget.productData['imageUrlList'][_imageIndex],
                    ),
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                      // Set the background color.
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  // left: 0,
                  right: 0,
                  // top: 100,
                  child: Container(
                    height: 50,
                    //width: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.productData['imageUrlList'].length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _imageIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                height: 50,
                                width: 50,
                                child: Image.network(
                                  widget.productData['imageUrlList'][index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                ),
              ],
            ),
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
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedSize =
                                          widget.productData['sizeList'][index];
                                    });
                                    print(_selectedSize);
                                  },
                                  child: Text(
                                    widget.productData['sizeList'][index],
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
            SizedBox(height: 60),
          ],
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
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
              _selectedSize = null; // Reset _selectedSize after adding to cart
            });
          }

          print('Working');
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
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
              Text(
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










// body: Column(
      //   children: [
      //     Container(
      //       height: 300,
      //       width: double.infinity,
      //       color: Colors.black,
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: ListView.builder(
      //               scrollDirection: Axis.horizontal,
      //               itemBuilder: (context, index) {
      //                 return Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: Container(
      //                     width: double.infinity,
      //                     color: Colors.white,
      //                     height: 280,
      //                     child: Image.network(
      //                       widget.productData['imageUrlList'][index],
      //                       fit: BoxFit.cover,
      //                     ),
      //                   ),
      //                 );
      //               },
      //               itemCount: widget.productData['imageUrlList'].length,
      //             ),
      //           ),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
