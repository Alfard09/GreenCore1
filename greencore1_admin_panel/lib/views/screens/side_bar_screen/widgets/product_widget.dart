import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  // const ProductWidget({super.key});

  Widget productData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final allProductData = snapshot.data!.docs[index];
              return Container(
                child: Row(
                  children: [
                    productData(
                      1,
                      Container(
                        height: 50,
                        width: 50,
                        child: Image.network(
                            allProductData['imageUrlList'][0].toString()),
                      ),
                    ),
                    productData(
                      2,
                      Text(
                        allProductData['productName'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    productData(
                      2,
                      Text(
                        "₹" + " " + allProductData['productPrice'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    productData(
                      2,
                      Text(
                        allProductData['quantity'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    productData(
                      1,
                      Text(
                        allProductData['category'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // productData(
                    //     1,
                    //     ElevatedButton(
                    //         onPressed: () {}, child: Text('View More'))),
                  ],
                ),
              );
            });
      },
    );
  }
}
