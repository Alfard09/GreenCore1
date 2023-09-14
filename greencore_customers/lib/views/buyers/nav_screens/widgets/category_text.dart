import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:greencore_1/views/buyers/nav_screens/widgets/home_product.dart';
import 'package:jumping_dot/jumping_dot.dart';

class CategoryText extends StatefulWidget {
  CategoryText({super.key});

  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _categoryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return JumpingDots(
                  color: Colors.green.shade600,
                  animationDuration: Duration(seconds: 5),
                );
              }

              return Column(
                children: [
                  Divider(),
                  Container(
                    height: 40,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              final categoryData = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                child: ActionChip(
                                  onPressed: () {
                                    setState(() {
                                      _selectedCategory =
                                          categoryData['categoryName'];
                                    });

                                    print(_selectedCategory);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: Colors.green.shade800,
                                  label: Text(
                                    // _categorylabel[index],
                                    categoryData['categoryName'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 15,

                          // highlightColor: Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            },
          ),
          //Text(_selectedCategory!),

          if (_selectedCategory != null)
            HomeproductWidget(categoryName: _selectedCategory!),
          if (_selectedCategory == null) HomeproductWidget(categoryName: ''),
        ],
      ),
    );
  }
}
