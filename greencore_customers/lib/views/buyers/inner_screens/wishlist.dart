import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jumping_dot/jumping_dot.dart';
import '../productDetail/product_detail_screen.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _wishlistStream =
        FirebaseFirestore.instance.collection('wishlist').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _wishlistStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: JumpingDots(
                color: Colors.green.shade600,
                animationDuration: Duration(seconds: 10),
              ),
            );
          }

          final wishlistItems = snapshot.data!.docs;

          if (wishlistItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              // print("Product data $productData['productName']");
              // var wishlistItem = wishlistItems[index].data();
              var documentId = wishlistItems[index].id;
              //print(wishlistData.data());

              return Dismissible(
                key: Key(documentId),
                onDismissed: (direction) {
                  _removeFromWishlist(documentId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item removed from wishlist'),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    // Print the entire document
                    print("Product name: ${productData['productName']}");
                    print("Product image: ${productData['Image']}");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      print("Product data $productData");
                      return ProductDetailScreen(
                        productData: productData.data(),
                      );
                    }));
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: Image.network(productData['Image']),
                      title: Text(productData['productName']),
                      subtitle: Text('Price:' +
                          '₹' +
                          ' ' +
                          '${productData['productPrice']}'),
                      trailing: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _removeFromWishlist(String documentId) async {
    await FirebaseFirestore.instance
        .collection('wishlist')
        .doc(documentId)
        .delete();
  }
}
