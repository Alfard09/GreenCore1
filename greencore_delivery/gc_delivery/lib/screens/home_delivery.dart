import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gc_delivery/screens/order_track.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _ordersStream =
      FirebaseFirestore.instance.collection('orders').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            "Order",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrderTrackingPage(orderId: document['orderId']);
                }));
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.delivery_dining),
                      ),
                      title: Text('Order ID: '),
                      subtitle: Text(
                        document['orderId'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.arrow_right),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 5),
                ],
              ),
            );
          }).toList());
        },
      ),
    );
  }
}
