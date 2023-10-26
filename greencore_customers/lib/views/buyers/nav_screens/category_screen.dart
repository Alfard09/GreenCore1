import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/inner_screens/all_product_screen.dart';
import 'package:jumping_dot/jumping_dot.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Categories',
            style: TextStyle(
              color: Colors.green.shade600,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoryStream,
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

          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  final categoryData = snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AllProductScreen(
                            categoryData: categoryData,
                          );
                        }));
                      },
                      contentPadding: EdgeInsets.all(10),
                      titleAlignment: ListTileTitleAlignment.center,
                      tileColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      leading: Container(
                        height: double.infinity,
                        child: Image.network(
                          categoryData['image'],
                          width: 50,
                          height: 50,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(categoryData['categoryName']),
                          Text(
                            'View Collections',
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  );
                })),
          );
        },
      ),
    );
  }
}
