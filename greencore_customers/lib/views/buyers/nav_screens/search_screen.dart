// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:greencore_1/views/buyers/productDetail/product_detail_screen.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   String _searchedValue = '';

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> _productsStream =
//         FirebaseFirestore.instance.collection('products').snapshots();
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.green.shade900,
//         elevation: 0,
//         title: TextFormField(
//           onChanged: (value) {
//             setState(() {
//               _searchedValue =
//                   value.trim(); // Trim whitespace from the search value
//             });
//           },
//           decoration: InputDecoration(
//             labelText: 'Search...',
//             labelStyle: TextStyle(color: Colors.white),
//             prefixIcon: Icon(
//               Icons.search,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//       body: _searchedValue.isEmpty
//           ? Center(
//               child: Text(
//                 'Search for Product',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             )
//           : StreamBuilder<QuerySnapshot>(
//               stream: _productsStream,
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Something went wrong');
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 final searchedData = snapshot.data!.docs.where((element) {
//                   return element['productName']
//                       .toString()
//                       .toLowerCase()
//                       .contains(_searchedValue.toLowerCase());
//                 });
//                 return ListView(
//                   children: searchedData.map((e) {
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) {
//                           return ProductDetailScreen(productData: e);
//                         }));
//                       },
//                       child: Card(
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               height: 100,
//                               width: 100,
//                               child: Image.network(e['imageUrlList'][0]),
//                             ),
//                             Expanded(
//                               child: Column(
//                                 // mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     e['productName'],
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                   Text(
//                                     '₹' + e['productPrice'].toStringAsFixed(2),
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w400,
//                                       color: Colors.green.shade900,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 );
//               },
//             ),
//     );
//   }
// }

//part 4
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greencore_1/views/buyers/productDetail/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchedValue = '';
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  // Function to fetch and update the suggestions from Firestore
  void updateSuggestions(String input) {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot snapshot) {
      final suggestions = snapshot.docs
          .where((doc) => doc['productName']
              .toString()
              .toLowerCase()
              .contains(input.toLowerCase()))
          .map((doc) => doc['productName'] as String)
          .toList();
      setState(() {
        _suggestions = suggestions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: Padding(
        //   padding: EdgeInsets.only(
        //       right: 0.0, left: 0), // Adjust the right padding as needed
        //   child: Icon(Icons.arrow_back_ios),
        // ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 20.5,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(); // This will navigate back to the previous page
                },
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            Expanded(
              child: TextFormField(
                autofocus: true,
                onTap: () {
                  setState(() {
                    _showSuggestions = true;
                    _searchedValue = '';
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _searchedValue = value.trim();
                    updateSuggestions(_searchedValue);
                    if (_searchedValue.isEmpty) {
                      _showSuggestions = true;
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search...',
                  //hintText: 'Search.....',

                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      // width: 10,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_searchedValue.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Center(
                child: Text(
                  'Search for Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else if (_showSuggestions)
            // Display autocomplete suggestions
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Card(
                elevation: 4, // Add elevation
                shadowColor: Colors.grey, // Add shadow color
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(16.0), // Round border
                // ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                margin: EdgeInsets.all(0),

                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(_suggestions[index]),
                          onTap: () {
                            // Set the selected suggestion as the search value
                            setState(() {
                              _searchedValue = _suggestions[index];
                              _showSuggestions = false;
                            });
                          },
                        ),
                        if (index < _suggestions.length - 1)
                          Divider(
                            height: 0,
                            color: Colors.grey, // Add divider lines
                          ),
                      ],
                    );
                  },
                ),
              ),
            )
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final searchedData = snapshot.data!.docs.where((element) {
                    return element['productName']
                        .toString()
                        .toLowerCase()
                        .contains(_searchedValue.toLowerCase());
                  });
                  return ListView(
                    children: searchedData.map((e) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProductDetailScreen(productData: e);
                          }));
                        },
                        child: Card(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(e['imageUrlList'][0]),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e['productName'],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '₹' +
                                          e['productPrice'].toStringAsFixed(2),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
