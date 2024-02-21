import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Report'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final orders = snapshot.data?.docs;
          return ListView.builder(
            itemCount: orders?.length,
            itemBuilder: (context, index) {
              var order = orders?[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color.fromARGB(255, 84, 37, 104),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      order?['productName'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.0),
                        Text(
                          'Buyer Email: ${order?['email']}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Quantity: ${order?['quantity']}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Total Price: \$${order?['totalPrice']}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Order Date: ${order?['orderDate'].toDate().toString()}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(order?['productImage'][0]),
                    ),
                    onTap: () {
                      // Add onTap functionality if needed
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
