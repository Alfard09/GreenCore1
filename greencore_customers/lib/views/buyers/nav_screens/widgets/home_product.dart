import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/productDetail/product_detail_screen.dart';
import 'package:jumping_dot/jumping_dot.dart';

class HomeproductWidget extends StatefulWidget {
  //const HomeproductWidget({super.key});
  final String categoryName;
  const HomeproductWidget({super.key, required this.categoryName});

  @override
  State<HomeproductWidget> createState() => _HomeproductWidgetState();
}

class _HomeproductWidgetState extends State<HomeproductWidget> {
  late Stream<QuerySnapshot> _productsStream;
  @override
  Widget build(BuildContext context) {
    // _productsStream = FirebaseFirestore.instance
    //     .collection('products')
    //     .where('category', isEqualTo: widget.categoryName)
    //     .snapshots();
    // if (widget.categoryName == null || widget.categoryName.isEmpty) {
    //   // Fetch all products if category is empty or null.
    //   _productsStream =
    //       FirebaseFirestore.instance.collection('products').snapshots();
    // } else {
    // Fetch products filtered by the specified category.
    _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.categoryName)
        .where('approved', isEqualTo: true)
        .snapshots();
    //}

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return JumpingDots(
            color: Colors.green.shade600,
            animationDuration: Duration(seconds: 5),
          );
        }

        return Container(
          // decoration: BoxDecoration(color: Colors.amber),
          height: 245,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              print(productData);
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductDetailScreen(
                      productData: productData,
                    );
                  }));
                },
                child: Container(
                  width: 170,
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius
                          .zero, // Set border radius to zero for square corners.
                      side: BorderSide(
                          color: Colors
                              .grey.shade50), // Add a border around the card.
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                productData['imageUrlList'][0],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            productData['productName'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            '₹' +
                                " " +
                                productData['productPrice'].toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w900),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, _) => SizedBox(
              width: 15,
            ),
            itemCount: snapshot.data!.docs.length,
          ),
        );
      },
    );
  }
}
