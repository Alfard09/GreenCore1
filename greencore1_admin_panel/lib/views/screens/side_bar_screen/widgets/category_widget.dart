// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CategoryWidget extends StatelessWidget {
//   const CategoryWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _categoriesStream =
//         FirebaseFirestore.instance.collection('categories').snapshots();
//     return StreamBuilder<QuerySnapshot>(
//       stream: _categoriesStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Colors.green,
//             ),
//           );
//         }

//         return GridView.builder(
//           itemCount: snapshot.data!.size,
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
//           itemBuilder: (context, index) {
//             final categoryData = snapshot.data!.docs[index];
//             return Column(
//               children: [
//                 SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: Image.network(
//                     categoryData['image'],
//                   ),
//                 ),
//                 Text(
//                   categoryData['categoryName'],
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

//edit and delete category functionality:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  //const CategoryWidget({Key? key});

  // Function to handle editing a category
  void editCategory(BuildContext context, String categoryId) {
    String newName = ''; // This will hold the updated category name

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(hintText: 'New Category Name'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Update the category name in Firestore
                FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoryId)
                    .update({'categoryName': newName}).then((value) {
                  Navigator.pop(context); // Close the dialog
                }).catchError((error) {
                  print('Failed to update category: $error');
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle deleting a category
  // void deleteCategory(String categoryId) {
  //   FirebaseFirestore.instance
  //       .collection('categories')
  //       .doc(categoryId)
  //       .delete()
  //       .then((value) {
  //     print('Category deleted successfully.');
  //   }).catchError((error) {
  //     print('Failed to delete category: $error');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        }

        return GridView.builder(
          itemCount: snapshot.data!.size,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
          itemBuilder: (context, index) {
            final categoryData = snapshot.data!.docs[index];
            return Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(
                    categoryData['image'],
                  ),
                ),
                Text(
                  categoryData['categoryName'],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Call the editCategory function to edit the category
                        editCategory(context, categoryData['categoryId']);
                      },
                      child: Text('Edit'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Add your delete functionality here
                        // deleteCategory(categoryData['categoryId']);
                        // You can use categoryData['categoryId'] to identify the category
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
