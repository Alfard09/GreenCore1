// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class WishlistPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wishlist'),
//       ),
//       body: _buildWishlist(context),
//     );
//   }

//   Widget _buildWishlist(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('wishlist').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         var wishlistItems = snapshot.data?.docs;

//         return wishlistItems!.isEmpty
//             ? Center(
//                 child: Text('Your wishlist is empty.'),
//               )
//             : ListView.builder(
//                 itemCount: wishlistItems.length,
//                 itemBuilder: (context, index) {
//                   var wishlistItem = wishlistItems[index].data();
//                   return ListTile(
//                     leading: Image.network(wishlistItem['productImage']),
//                     title: Text(wishlistItem['productName']),
//                     subtitle: Text('Price: \$${wishlistItem['productPrice']}'),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         // Remove item from wishlist when delete button is pressed
//                         _removeFromWishlist(wishlistItems[index].id);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Item removed from wishlist'),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               );
//       },
//     );
//   }

//   void _removeFromWishlist(String documentId) async {
//     await FirebaseFirestore.instance
//         .collection('wishlist')
//         .doc(documentId)
//         .delete();
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../productDetail/product_detail_screen.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'),
      ),
      body: _buildWishlist(context),
    );
  }

  Widget _buildWishlist(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('wishlist').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final wishlistItems = snapshot.data!.docs;
        // final productData = snapshot.data!.docs[index];

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
          itemCount: wishlistItems.length,
          itemBuilder: (context, index) {
            var wishlistItem = wishlistItems[index].data();
            // print("Wishlist Item: $wishlistItem");
            return _buildWishlistItem(
                context, wishlistItem, wishlistItems[index].id);
          },
        );
      },
    );
  }

  Widget _buildWishlistItem(BuildContext context,
      Map<String, dynamic> wishlistItem, String documentId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(productData: wishlistItem),
          ),
        );
      },
      child: Dismissible(
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
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Image.network(wishlistItem['productImage']),
            title: Text(wishlistItem['productName']),
            subtitle: Text('Price: \$${wishlistItem['productPrice']}'),
            trailing: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ),
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
