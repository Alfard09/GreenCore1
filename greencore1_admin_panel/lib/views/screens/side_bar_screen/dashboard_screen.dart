// import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   static const String routeName = '\DashboardScreen';

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         alignment: Alignment.topLeft,
//         padding: const EdgeInsets.all(10),
//         child: Text(
//           "Dashboard",
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 30,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ), // Add some spacing between "Dashboard" and the boxes
            FutureBuilder(
              future: _getCounts(),
              builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final productsCount = snapshot.data!['products'];
                  final sellersCount = snapshot.data!['sellers'];
                  final usersCount = snapshot.data!['users'];

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildBox("Products", productsCount.toString()),
                            SizedBox(width: 20),
                            _buildBox("Sellers", sellersCount.toString()),
                            SizedBox(width: 20),
                            _buildBox("Users", usersCount.toString()),
                          ],
                        ),
                      ]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, int>> _getCounts() async {
    final productsQuery =
        await FirebaseFirestore.instance.collection('products').get();
    final sellersQuery =
        await FirebaseFirestore.instance.collection('vendors').get();
    final usersQuery =
        await FirebaseFirestore.instance.collection('buyers').get();

    final productsCount = productsQuery.docs.length;
    final sellersCount = sellersQuery.docs.length;
    final usersCount = usersQuery.docs.length;

    return {
      'products': productsCount,
      'sellers': sellersCount,
      'users': usersCount,
    };
  }

  Widget _buildBox(String title, String count) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: Color.fromARGB(207, 48, 165, 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          SizedBox(height: 5),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
