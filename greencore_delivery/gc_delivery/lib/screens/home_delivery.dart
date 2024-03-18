import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gc_delivery/screens/order_track.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _ordersStream =
                    FirebaseFirestore.instance.collection('orders').snapshots();
              });
            },
          ),
        ],
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

          List<DocumentSnapshot> newOrders = [];
          List<DocumentSnapshot> ongoingOrders = [];
          List<DocumentSnapshot> historyOrders = [];
          snapshot.data!.docs.forEach((DocumentSnapshot document) {
            Map<String, dynamic>? data =
                document.data() as Map<String, dynamic>?;

            if (data != null) {
              print('Document ID: ${document.id}');
              print('Document data: $data');

              dynamic status = data['status'];
              String statusLowercase = status
                  .toString()
                  .toLowerCase(); // Convert status to lowercase

              print('Status: $statusLowercase'); // Print status for debugging

              if (statusLowercase == 'order placed') {
                // Check lowercase status
                newOrders.add(document);
              } else if (statusLowercase == 'shipped' ||
                  statusLowercase == 'out for delivery') {
                ongoingOrders.add(document);
              } else if (statusLowercase == 'delivered') {
                historyOrders.add(document);
              }
            }
          });

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'New'),
                    Tab(text: 'Ongoing'),
                    Tab(text: 'History'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      newOrders.isEmpty
                          ? Center(
                              child: Text(
                                'No Orders',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : _buildOrderList(newOrders),
                      ongoingOrders.isEmpty
                          ? Center(
                              child: Text(
                                'No Orders',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : _buildOrderList(ongoingOrders),
                      _buildOrderList(historyOrders),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<DocumentSnapshot> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot document = orders[index];
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
      },
    );
  }
}
